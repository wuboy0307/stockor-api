# rubocop:disable IndentationWidths
module Skr
    module API

        # The Controller handles querying models
        # using either pre-defined scopes or hash based queries;
        # and also including optional associations with the reply
        #
        # It assigns the following meaning the these parameters.
        #    * f: (fields)   Include the following fields (usually methods) with the reply
        #    * w: (with)     Uses the defined scope to query and/or add extra data to the model
        #    * q: (query)    Query the model using fields and values
        #         it is an array of clauses, which can be either forms
        #         { field: value }, or { field: { op: 'like', value: 'value%' } }
        #    * i: (include)  Include associations along with the model in the reply
        #    * o: (order)    Order by, { field => "ASC|DESC" }
        #    * l: (limit)    Limit the returned rows to the count
        #    * s: (start)    Start the query at the given offset (for paging)
        #
        # The parameters are deliberately shortened so they can be used in
        # query parameters without blowing the URL up to an unacceptable length

        class Controller

            attr_reader :model, :user, :params
            class_attribute :nested_attribute

            def initialize(model, authentication, params)
                @model  = model
                @user   = authentication.current_user
                @params = params
            end

            def perform_retrieval
                query   = build_query
                options = build_reply_options

                options[:total_count] = query.dup.count if should_include_total_count?(options)
                query   = add_modifiers_to_query(query)
                if params[:id]
                    query  = query.where(id: params[:id]).first!
                end
                build_reply(query, :retrieve, options)
            end

            def perform_creation
                json = model.sanitize_json(params[:data] || {}, user)
                record  = model.new(json)
                options = build_reply_options.merge(success: record.save)
                build_reply(record, :create, options)
            end

            def perform_update
                record   = build_query.first
                record.assign_attributes model.sanitize_json(params[:data] || {}, user)
                options = build_reply_options.merge(success: record.save)
                build_reply(record, :update, options)
            end

            def perform_destroy
                record = model.find(params[:id])
                record.destroy
                build_reply(record, :destroy, {})
            end

          protected

            # json methods
            # constructs a Hash with success, messages, and data keys and
            # populates them appropriately

            def build_reply(query, type, options)
                success = options[:success].nil? ? true : options[:success]
                json = {}
                if query.is_a?(ActiveRecord::Base) && query.errors.any?
                    json[:errors] = {}
                    success = false
                    query.errors.each{ | attr, message |
                        json[:errors][attr] = message
                    }
                end
                if options[:total_count]
                    json[:total] = options.delete(:total_count)
                end
                json.merge!({
                                :success => success,
                                :message => options[:messsage] || json_status_str(query, type.to_s.capitalize, success),
                                :data    => success ? query.as_json(options) : []
                            })
                return json
            end

            def json_status_str(record, type, success)
                if success
                    return type + " succeeded"
                elsif record
                    return type + " failed: " + record.errors.full_messages.join("; ")
                else
                    return "Record not found"
                end
            end

            # reply options

            def should_include_total_count?(params)
                params[:l] && params[:s] && ! params[:id]
            end

            def build_reply_options
                options = {}
                if params.has_key?(:i)
                    options[:include] = [*(params[:i])].each_with_object({}) do |association, includes|
                        includes.merge! build_allowed_associations(association, user)
                    end
                end

                if params.has_key?(:f)
                    options[:methods] = [*(params[:f])].select{|f| model.has_exported_method?(f,user) }
                end
                options
            end

            def build_allowed_associations(association, user, model_class=self.model)
                includes = {}
                if association.is_a?(Hash)
                    association.each do |include_name, sub_associations|
                        if model_class.has_exported_association?(include_name, user) &&
                           ( reflection = model_class.reflect_on_association( include_name.to_sym ) )
                            sub_includes = includes[include_name.to_sym] = {}
                            allowed = build_allowed_associations( sub_associations, user, reflection.klass )
                            unless allowed.empty?
                                sub_includes[:include] ||= []
                                sub_includes[:include] << allowed
                            end
                        end
                    end
                elsif association.is_a?(Array)
                    association.each do | sub_association |
                        if model_class.has_exported_association?(sub_association, user)
                            includes.merge! build_allowed_associations( sub_association, user, model_class )
                        end
                    end
                else
                    includes[ association.to_sym ] = {} if  model_class.has_exported_association?(association,user)
                end
                includes
            end

            # query options

            def build_query(query = model.all)
                if nested_attribute && params[nested_attribute]
                    query = query.where(Hash[ nested_attribute, params[nested_attribute]])
                end
                if params[:w]
                    query = add_scope_to_query(query)
                end
                if params[:q].is_a?(Hash)
                    query = add_hash_to_query(query, params[:q])
                end
                query
            end

            def add_modifiers_to_query(query)
                query = query.limit(query_limit_size)
                query = query.offset(params[:s].to_i) if params[:s]

                if params[:i].present?
                    allowed_includes = [ *params[:i] ].each_with_object([]) do |desired, results|
                        if desired.is_a?(Hash)
                            nested = {}
                            desired.each do | name, sub_associations |
                                nested[name.to_sym] = sub_associations if model.has_exported_association?(name,user)
                            end
                            results.push(nested) unless nested.empty?
                        else
                            results.push( include.to_sym ) if model.has_exported_association?(include,user)
                        end
                    end
                    query = query.includes(allowed_includes) unless allowed_includes.empty?
                end
                if params[:o].present?
                    params[:o].each do | fld, dir |
                        query = query.order( fld.gsub(/[^\w|^\.]/,'') + ' ' + ( ( 'asc' == dir.downcase ) ? 'ASC' : 'DESC' ) )
                    end
                end
                query

            end

            def query_limit_size
                limit = max_query_results_size
                params[:l] ? [ params[:l].to_i, limit ].min : limit
            end

            def max_query_results_size
                250 # should be enough for everybody, amirite?
            end

            def add_scope_to_query(query)
                params[:w].each do | name, arg |
                    if model.has_exported_scope?(name,user)
                        args = [name]
                        args.push( arg ) unless arg.blank?
                        query = query.send( *args )
                    end
                end
                query
            end

            def add_hash_to_query(query, clause)
                clause.each do | field, value |
                    next unless ( field = convert_field_to_arel(field) )
                    condition = if value.is_a?(Hash) && value.has_key?('value')
                                    api_op_string_to_arel_predicate(field, value['op'], value['value'])
                                else
                                    api_op_string_to_arel_predicate(field, nil, value)
                                end
                    query = query.where(condition)
                end
                query
            end

            def convert_field_to_arel(field)
                if field.include?('.')
                    (table_name, field_name) = field.split('.')
                    if model.has_exported_join_table?(table_name, user)
                        Arel::Table.new(table_name)[field_name]
                    else
                        nil
                    end
                else
                    model.arel_table[field]
                end
            end

            # complete list: https://github.com/rails/arel/blob/master/lib/arel/predications.rb
            def api_op_string_to_arel_predicate( field, op, value )
                case op
                when 'eq'   then field.eq(value)
                when 'ne'   then field.not_eq(value)
                when 'lt'   then field.lt(value)
                when ( op=='in' && value=~/.*:.*/ ) then field.in( Range.new( *value.split(':') ) )
                when 'gt'   then field.gt(value)
                when 'like' then field.matches( value )
                else
                    value =~ /%/ ? field.matches( value ) : field.eq( value )
                end
            end

        end
    end

end

module Skr
    module API
        class Root < Grape::API

            helpers Skr::API::AuthenticationHelper
            helpers Skr::API::RequestWrapper
            version 'v1', using: :header, vendor: 'stockor'
            format :json
            #use Rack::Session::Cookie
            error_formatter :json, Skr::API::ErrorFormmater

            rescue_from ActiveRecord::InvalidForeignKey do |e|
                ErrorFormmater.handle_fk_exception(e, env[:model])
            end
            rescue_from ActiveRecord::RecordNotFound do |e|
                ErrorFormmater.handle_not_found_exception(e, env[:model])
            end
            rescue_from :all do |e|
                ErrorFormmater.handle_exception(env[:model].to_s.demodulize + " raised " + e.message, 500, e)
            end

            def self.build_route(model, options = {})

                path = options[:path] || model.api_path
                controller = options[:controller] || Skr::API::Controller

                parent_attribute = false
                prefix = if options[:under]
                             parent_attribute = options[:parent_attribute] || options[:under].underscore.singularize+'_id'
                             before do
                                 if params[parent_attribute]
                                     params[:nested_attribute] = Hash[ parent_attribute, params[parent_attribute] ]
                                 end
                             end
                         else
                             ''
                         end

                # index
                get "#{prefix}/#{path}(/:id)" do
                    perform_request(model) do |authentication|
                        controller.new(model, authentication, params).perform_retrieval
                    end
                end

                # create
                post "#{prefix}/#{path}" do
                    perform_request(model) do |authentication|
                        controller.new(model, authentication, params).perform_creation
                    end
                end

                unless options[:immutable]
                    patch "#{prefix}/#{path}/:id" do
                        perform_request(model) do |authentication|
                            controller.new(model, authentication, params).perform_update
                        end
                    end

                    # update
                    put "#{prefix}/#{path}/:id" do
                        perform_request(model) do |authentication|
                            controller.new(model, authentication, params).perform_update
                        end
                    end

                    unless options[:indestructible]
                        # destroy
                        delete "#{prefix}/#{path}/:id" do
                            perform_request(model) do |authentication|
                                controller.new(model, authentication, params).perform_delete
                            end
                        end
                    end

                end

            end

        end
    end
end

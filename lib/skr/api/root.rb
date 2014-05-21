module Skr
    module API
        class Root < Grape::API

            helpers Skr::API::AuthenticationHelper

            version 'v1', using: :header, vendor: 'stockor'
            format :json

            error_formatter :json, Skr::API::ErrorFormmater

            # rescue_from ActiveRecord::InvalidForeignKey do |e|
            #     ErrorFormmater.handle_fk_exception(e, env[:model])
            # end
            # rescue_from ActiveRecord::RecordNotFound do |e|
            #     ErrorFormmater.handle_not_found_exception(e, env[:model])
            # end
            # rescue_from :all do |e|
            #     ErrorFormmater.handle_exception(env[:model].to_s.demodulize + " raised " + e.message, 500, e)
            # end

            def self.build_route(model, options = {})

                path = options[:path] || model.to_s.demodulize.pluralize.underscore.dasherize
                rest_controller = options[:controller] || Skr::API::Controller

                parent_attribute = false
                prefix = if options[:under]
                             parent_attribute = options[:parent_attribute] || options[:under].underscore.singularize+'_id'
                             options[:under] + "/:#{parent_attribute}"
                         else
                             ''
                         end

                # index
                get "#{prefix}/#{path}(/:id)" do
                    env[:model]=model
                    auth = authenticate!(model, :get)
                    controller = rest_controller.new(model, auth, params)
                    controller.nested_attribute = parent_attribute if parent_attribute
                    controller.perform_retrieval
                end

                # create
                post "#{prefix}/#{path}" do
                    env[:model]=model
                    auth = authenticate!(model, :post)
                    controller = rest_controller.new(model, auth, params)
                    controller.nested_attribute = parent_attribute if parent_attribute
                    response = controller.perform_creation
                    status(406) if false == response[:success]
                    response
                end

                unless options[:immutable]

                    # update
                    put "#{prefix}/#{path}/:id" do
                        env[:model]=model
                        auth = authenticate!(model, :put)
                        controller = rest_controller.new(model, auth, params)
                        controller.nested_attribute = parent_attribute if parent_attribute
                        response = controller.perform_update
                        status(406) if false == response[:success]
                        response
                    end

                    unless options[:indestructible]
                        # destroy
                        delete "#{prefix}/#{path}/:id" do
                            env[:model]=model
                            auth = authenticate!(model, :delete)
                            controller = rest_controller.new(model, auth, params)
                            controller.nested_attribute = parent_attribute if parent_attribute
                            response = controller.perform_destroy
                            status(400) if false == response[:success]
                            response
                        end
                    end

                end



            end

        end
    end
end

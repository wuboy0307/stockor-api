module Skr
    module API
        module RequestWrapper


            def perform_request(model)
                authentication = Skr::API.config.authentication_provider.new(environment:env, params:params)

                unless authentication.allowed_access_to?(model, request.request_method )
                    error!({ errors: {user: "Access Denied"}, message: authentication.error_message }, 401)
                end
                ::Skr::UserProxy.scoped_to(authentication.current_user) do | user |
                    Skr::Core.logger.debug  "User #{user.id} (#{user.login}) Data: #{request.params.data.to_json}"
                    response = yield authentication
                    status(406) if false == response
                    response
                end
            end

        end
    end
end

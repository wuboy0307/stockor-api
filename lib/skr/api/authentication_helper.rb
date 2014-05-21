module Skr
    module API
        module AuthenticationHelper
            def authenticate!(model, type)
                auth = Skr::API.config.authentication_provider.new(environment:env, params:params)
                unless auth.allowed_access_to?(model, type)
                    error!({ errors: {user: "Access Denied"}, message: auth.error_message }, 401)
                end
                auth
            end
        end
    end
end

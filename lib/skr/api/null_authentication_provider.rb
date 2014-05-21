module Skr
    module API
        class NullAuthenticationProvider

            def initialize(environment:nil, params:nil)
            end

            def current_user
                nil
            end

            def error_message
                ''
            end

            def allowed_access_to?(klass, type)
                true
            end
        end
    end
end

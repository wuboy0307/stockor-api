module Skr
    module API
        class Configuration < Skr::Core::Configuration

            # What class to use for providing the current user
            config_option :authentication_provider, Skr::API::NullAuthenticationProvider

        end

        class << self
            @@config = Configuration.new
            def config
                @@config
            end

            def configure
                yield(@config)
            end
        end

    end

end

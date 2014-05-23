require_relative '../skr/api'

# This is a "sham" namespace that only exists so that
# Bundler will pull in the Skr::Api namespace
module Stockor
    module API
        VERSION = Skr::Core::VERSION
    end
end

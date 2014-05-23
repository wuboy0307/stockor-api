# We declare the version on the Skr module
# Since the API class inherits from Grape, it's cumbersome to require Grape and
# open the API class premeturely here
# The API copies the version ito Skr::API::VERSION in api.rb
module Skr
    module API
        VERSION = '0.2'
    end
end

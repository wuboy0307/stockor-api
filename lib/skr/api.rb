require 'grape'

require 'skr/core'

module Skr
    module API
        def self.logger
            ::Grape::API.logger
        end
    end
end

require_rel 'api/*_helper.rb'
require_relative 'api/model_api_path'
require_relative 'api/null_authentication_provider'
require_relative 'api/configuration'
require_relative 'api/request_wrapper'
require_relative 'api/error_formatter'
require_relative 'api/controller'
require_relative 'api/root'
require_relative 'api/routes'
require_relative 'api/default_records'

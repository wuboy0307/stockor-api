require 'grape'

require 'skr/core'

module Skr
    module API
    end
end

require_rel 'api/*_helper.rb'
require_relative 'api/null_authentication_provider'
require_relative 'api/configuration'
require_relative 'api/null_authentication_provider'
require_relative 'api/error_formatter'
require_relative 'api/controller'
require_relative 'api/root'
require_relative 'api/routes'

#require 'require_all'
#require_rel 'api/*.rb'

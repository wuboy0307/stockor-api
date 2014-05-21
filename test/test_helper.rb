require 'skr/core/testing/helper'
require 'skr/api'
require "rack/test"

module TestPatches
    def app
        Skr::API::Root.new
    end

    def json_body
        Hashie::Mash.new ActiveSupport::JSON.decode( last_response.body )
    end

    def json_data
        json_body['data']
    end
end

Skr::TestCase.send :include, TestPatches
Skr::TestCase.send :include, Rack::Test::Methods

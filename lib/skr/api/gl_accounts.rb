require_relative 'controller'

module Skr
    module API

        class GlAccounts < Controller

            restful_routes_for Skr::GlAccount, indestructible: true

        end

    end
end

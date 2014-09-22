module Skr
    module API

        def self.default_records
            defaults = {
                location:      Skr::Location.default.as_json(only:[:id, :code, :name]),
                customer_term: Skr::PaymentTerm.find_by_code(Skr::Core.config.customer_terms_code)
                  .as_json(only:[:id,:code,:description]),
                vendor_term:   Skr::PaymentTerm.find_by_code(Skr::Core.config.vendor_terms_code)
                  .as_json(only:[:id,:code,:description]),
                tax_sku: Skr::Sku.find_by_code(Skr::Core.config.tax_sku_code)
                  .as_json(only:[:id,:code,:description]),
                ship_sku: Skr::Sku.find_by_code(Skr::Core.config.ship_sku_code)
                  .as_json(only:[:id,:code,:description])
            }
            gl = defaults[:gl] = {}
            Core.config.default_gl_accounts.each do |type, number|
                gl[type] = GlAccount.default_for(type).as_json(only:[:id,:code,:name])
            end
            defaults
        end

    end
end

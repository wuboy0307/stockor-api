require_relative 'test_helper'

class SalesOrderTest < Skr::TestCase

    def test_creation
        so_id = 0
        assert_difference ->{SalesOrder.count}, 1 do
            post "sales-orders", {
                data: {
                    customer_id: skr_customers(:argosity).id,
                    terms_id: skr_payment_terms(:cash).id,
                    lines: [
                      { qty: 12, sku_loc_id: skr_sku_locs(:hatdefault).id }
                    ]
                }
            }
            so_id = json_data.id
        end
    end

    def test_nested_lines
        so = skr_sales_orders(:first)
        get "sales-orders/#{so.id}/lines"
        assert_equal 1, json_data.count
        assert_equal 'STRING', json_data.first.sku_code
    end

end

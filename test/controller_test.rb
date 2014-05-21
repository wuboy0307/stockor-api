require_relative 'test_helper'

class ControllerTest < Skr::TestCase

    def test_exception_handling
        address = Skr::Location.default.address
        delete "/addresses/#{address.id}"
        assert_equal false, json_body.success
        assert_match "Unable to delete Address", json_body.message
        assert_equal 400, last_response.status

        delete "/addresses/903903923"
        assert_equal false, json_body.success
        assert_equal 404, last_response.status

        get "/addresses/903903923"
        assert_equal false, json_body.success
        assert_equal 404, last_response.status

        get "/addresses/#{address.id}"
        assert_equal json_data.id, address.id
        assert_equal 200, last_response.status

        get "/addresses"
        assert_equal Skr::Address.ids, json_data.map(&:id)
    end

    def test_loading_fields
        so = skr_sales_orders(:first)
        get "sales-orders/#{so.id}", { f: ['customer_code'] }
        assert_equal 'ARGOSITY', json_data.customer_code
    end

    def test_loading_scopes
        so = skr_sales_orders(:first)
        get "sales-orders/#{so.id}", { w: {'with_amount_details'=>'t'} }
        assert_equal so.total.to_s, json_data.total
    end

    def test_querying
        so = skr_sales_orders(:first)
        get "sales-orders", { q: {'po_num'=>'First'} }
        assert_equal so.id, json_data.first.id
    end

    def test_querying_with_scope
        largest = SalesOrder.with_amount_details.sort_by{ |so| so.total }.last
        get "sales-orders", {
            w: {'with_amount_details'=>'t'},
            q: { 'details.total'=> { op:'gt', value: largest.total-0.01 } }
        }
        assert_equal 1, json_data.count
        assert_equal largest.id, json_data.first.id
    end

    def test_loading_includes
        so = skr_sales_orders(:first)
        get "sales-orders/#{so.id}", { i: [{ 'lines' => ['sku'] } ] }
        assert_equal so.id, json_data.id
        assert_equal 1, json_data.lines.length
        assert_equal 'STRING', json_data.lines.first.sku.code
    end

    def test_sort_order
        get "sales-orders", { o: {'po_num'=>'asc' } }
        assert_equal SalesOrder.pluck('po_num').sort, json_data.map{ |so| so.po_num }
    end

    def test_limiting
        get "sales-orders", { o: {'po_num'=>'asc' }, l: 1 }
        assert_equal 1, json_data.length
        assert_equal "COMPLETE", json_data.first.po_num
    end

    def test_offset
        get "sales-orders", { o: {'po_num'=>'asc' }, l: 1, s:1 }
        assert_equal 1, json_data.length
        assert_equal "First", json_data.first.po_num
    end

end

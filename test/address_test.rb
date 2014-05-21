require_relative 'test_helper'

class AddressTest < Skr::TestCase

    def test_create
        assert_difference ->{Address.count}, 1 do
            post "/addresses", data: {
                name: "Nathan"
            }
            assert_equal 201, last_response.status
        end
    end

    def test_delete
        post "/addresses", data: {
            name: "Big Data WH"
        }
        address = json_data
        assert_difference ->{Address.count}, -1 do
            delete "/addresses/#{address.id}"
            assert_equal 200, last_response.status
        end
    end

    def test_query
        get "/addresses", { q: { postal_code:98144, name:{ op:'like', value:'Amazon%'} } }
        assert_equal skr_addresses(:amazon).id, json_data.first.id
    end

    def test_update
        address = skr_addresses(:amazon)
        put "/addresses/#{address.id}", data: { city: 'Foo Town' }
        assert_equal 'Foo Town', address.reload.city
    end

end

require_relative 'test_helper'

class GlAccountsTest < Skr::TestCase

    def test_root
        get '/gl-accounts', l: 7
        assert last_response.ok?
        assert_equal( 7, json_data.count )
    end

    def test_create
        post '/gl-accounts', { data: { number: '9999', name: 'TEST', description: 'A testing GL Account' } }
        assert_equal 201, last_response.status
        refute_empty Skr::GlAccount.where(number: '9999')
    end

    def test_update
        account = Skr::GlAccount.first
        put "/gl-accounts/#{account.id}", { data: { name: 'TestUpdate'} }
        assert_equal 'TestUpdate', account.reload.name
    end

    def test_destroy
        account = Skr::GlAccount.first
        delete "/gl-accounts/#{account.id}"
        assert_equal 405, last_response.status
    end

end

require_relative 'test_helper'

class GlTransactionTest < Skr::TestCase


    def test_create
        assert_difference ->{ GlManualEntry.count }, 1 do
            post '/gl-manual-entries', { data:
                {
                    notes: 'posting',
                    gl_transaction: {
                        description: 'A test',
                        credits:[{
                                  account_number: '180001',
                                  amount: 21.11
                                 }],
                        debits:[{
                                  account_number: '380001',
                                  amount: -21.11,
                                  is_debit: true
                          }]
                    }
                }
              }
            assert_equal 201, last_response.status
        end

    end

    # def test_update
    #     account = Skr::GlAccount.first
    #     put "/gl-accounts/#{account.id}", { data: { name: 'TestUpdate'} }
    #     assert_equal 'TestUpdate', account.reload.name
    # end

    # def test_destroy
    #     account = Skr::GlAccount.first
    #     delete "/gl-accounts/#{account.id}"
    #     assert_equal 405, last_response.status
    # end

end

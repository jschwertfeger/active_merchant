require 'test_helper'

class PostFinanceHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  SECRET = 'passw0rd'

  def setup
    @helper = PostFinance::Helper.new('order-500', 'psp-123', :amount => 500, :currency => 'CHF', :secret => SECRET)
  end

  def test_secret_required
    assert_raises ArgumentError do
      PostFinance::Helper.new('order-500', 'psp-123', :amount => 500, :currency => 'CHF')
    end
    assert_nothing_raised do
      PostFinance::Helper.new('order-500', 'psp-123', :amount => 500, :currency => 'CHF', :secret => SECRET)
    end
  end

  def test_basic_helper_fields
    assert_field 'ORDERID', 'order-500'
    assert_field 'PSPID', 'psp-123'
    assert_field 'AMOUNT', '500'
    assert_field 'CURRENCY', 'CHF'
  end

  def test_customer_fields
    @helper.customer :name => 'Joe Doe', :email => 'joe@doe.com', :phone => '1234567890'
    assert_field 'CN', 'Joe Doe'
    assert_field 'EMAIL', 'joe@doe.com'
    assert_field 'OWNERTELNO', '1234567890'
  end

  def test_address_mapping
    @helper.billing_address :address1 => '1 My Street',
                            :address2 => '',
                            :city => 'Leeds',
                            :zip => 'LS2 7EE',
                            :country => 'GB'

    assert_field 'OWNERADDRESS', '1 My Street'
    assert_field 'OWNERTOWN', 'Leeds'
    assert_field 'OWNERZIP', 'LS2 7EE'
    assert_field 'OWNERCTY', 'GB'
  end

  def test_misc_fields
    @helper.template_url = 'https://foobar.com/template'
    @helper.return_url = 'https://foobar.com/return'
    @helper.cancel_return_url = 'https://foobar.com/cancel'
    @helper.description = 'Description...'

    assert_field 'TP', 'https://foobar.com/template'
    assert_field 'CATALOGURL', 'https://foobar.com/return'
    assert_field 'CANCELURL', 'https://foobar.com/cancel'
    assert_field 'COM', 'Description...'
  end

  def test_unknown_mapping
    assert_nothing_raised do
      @helper.company_address :address => '500 Dwemthy Fox Road'
    end
  end
end

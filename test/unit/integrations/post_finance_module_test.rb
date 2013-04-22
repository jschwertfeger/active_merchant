require 'test_helper'

class PostFinanceModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def test_notification_method
    assert_instance_of PostFinance::Notification, PostFinance.notification('name=cody')
  end

  def test_test_mode
    ActiveMerchant::Billing::Base.integration_mode = :test
    assert_equal 'https://e-payment.postfinance.ch/ncol/test/orderstandard_utf8.asp', PostFinance.service_url
  end

  def test_production_mode
    ActiveMerchant::Billing::Base.integration_mode = :production
    assert_equal 'https://e-payment.postfinance.ch/ncol/prod/orderstandard_utf8.asp', PostFinance.service_url
  end

  def test_invalid_mode
    ActiveMerchant::Billing::Base.integration_mode = :foobar
    assert_raise(StandardError) { PostFinance.service_url }
  end

end

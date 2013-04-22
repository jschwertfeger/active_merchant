require 'test_helper'

class PostFinanceNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  SECRET = 'passw0rd'
  
  def setup
    @post_finance = PostFinance::Notification.new(http_raw_data, :secret => SECRET)
  end

  def test_accessors
    assert @post_finance.complete?
    assert_equal 'Completed', @post_finance.status
    assert_equal '123', @post_finance.transaction_id
    assert_equal '9.90', @post_finance.gross
    assert_equal 'CHF', @post_finance.currency
    assert !@post_finance.test?
    assert_equal nil, @post_finance.received_at
  end

  def test_compositions
    assert_equal Money.new(990, 'CHF'), @post_finance.amount
  end

  def test_secret_required
    assert_raises ArgumentError do
      PostFinance::Notification.new(http_raw_data, {})
    end
    assert_nothing_raised do
      PostFinance::Notification.new(http_raw_data, :secret => SECRET)
    end
  end

  def test_status_completed
    notification = PostFinance::Notification.new(http_raw_data, :secret => SECRET)
    assert_equal 'Completed', notification.status
    notification = PostFinance::Notification.new(http_raw_data.sub(/status=5/, 'status=9'), :secret => SECRET)
    assert_equal 'Completed', notification.status
  end

  def test_status_pending
    notification = PostFinance::Notification.new(http_raw_data.sub(/status=5/, 'status=51'), :secret => SECRET)
    assert_equal 'Pending', notification.status
    notification = PostFinance::Notification.new(http_raw_data.sub(/status=5/, 'status=91'), :secret => SECRET)
    assert_equal 'Pending', notification.status
  end

  def test_status_failed
    notification = PostFinance::Notification.new(http_raw_data.sub(/status=5/, 'status=0'), :secret => SECRET)
    assert_equal 'Failed', notification.status
  end


  def test_acknowledgement
    data = {'ORDERID' => '123',
            'AMOUNT' => '9.90',
            'CURRENCY' => 'CHF',
            'PM' => 'CreditCard',
            'ACCEPTANCE' => '04306B',
            'STATUS' => '5',
            'CARDNO' => 'XXXXXXXXXXXX1111',
            'PAYID' => '654321',
            'NCERROR' => '0',
            'BRAND' => 'VISA',
            'ED' => '0215',
            'TRXDATE' => '12/25/13',
            'CN' => 'Joe+Doe',
            'SHASIGN' => 'E6BFE18FB9A2E58CE6A2725A1E017ADC709E6910C7B7EDBEE9A19C364B73E6CD'}
    data = data.map { |key, value| "#{key}=#{value}" }.join('&')
    notification = PostFinance::Notification.new(data, :secret => SECRET)
    assert notification.acknowledge
  end

  def test_respond_to_acknowledge
    assert @post_finance.respond_to?(:acknowledge)
  end

  private
  def http_raw_data
    'ORDERID=123&AMOUNT=9.90&CURRENCY=CHF&PM=CreditCard&ACCEPTANCE=04306B&STATUS=5&CARDNO=XXXXXXXXXXXX1111&PAYID=654321&NCERROR=0&BRAND=VISA&ED=0215&TRXDATE=12/25/13&CN=Joe+Doe&SHASIGN=E6BFE18FB9A2E58CE6A2725A1E017ADC709E6910C7B7EDBEE9A19C364B73E6CD'
  end
end

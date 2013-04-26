require File.dirname(__FILE__) + '/post_finance/common.rb'
require File.dirname(__FILE__) + '/post_finance/helper.rb'
require File.dirname(__FILE__) + '/post_finance/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module PostFinance

        mattr_accessor :test_url
        self.test_url = 'https://e-payment.postfinance.ch/ncol/test/orderstandard_utf8.asp'

        mattr_accessor :production_url
        self.production_url = 'https://e-payment.postfinance.ch/ncol/prod/orderstandard_utf8.asp'

        def self.service_url
          mode = ActiveMerchant::Billing::Base.integration_mode
          case mode
            when :production
              self.production_url
            when :test
              self.test_url
            else
              raise StandardError, "Integration mode set to an invalid value: #{mode}"
          end
        end

        def self.notification(post, options={})
          Notification.new(post, options)
        end
      end
    end
  end
end

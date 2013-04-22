module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class PostFinanceGateway < Gateway
      self.test_url = 'https://e-payment.postfinance.ch/ncol/test/orderstandard.asp'
      self.live_url = 'https://e-payment.postfinance.ch/ncol/prod/orderstandard.asp'

      self.default_currency = 'CHF'
      self.money_format = :cents
      self.supported_countries = ['CH']
      self.supported_cardtypes = [:visa, :master, :american_express, :diners_club, :jcb]
      self.homepage_url = 'http://www.postfinance.ch/'
      self.display_name = 'PostFinance'

      def initialize(options = {})
        #requires!(options, :login, :password)
        super
      end

      def authorize(money, creditcard, options = {})
        post = {}
        add_invoice(post, options)
        add_creditcard(post, creditcard)
        add_address(post, creditcard, options)
        add_customer_data(post, options)

        commit('authonly', money, post)
      end

      def purchase(money, creditcard, options = {})
        post = {}
        add_invoice(post, options)
        add_creditcard(post, creditcard)
        add_address(post, creditcard, options)
        add_customer_data(post, options)

        commit('sale', money, post)
      end

      def capture(money, authorization, options = {})
        commit('capture', money, post)
      end

      private

      def add_customer_data(post, options)
      end

      def add_address(post, creditcard, options)
      end

      def add_invoice(post, options)
      end

      def add_creditcard(post, creditcard)
      end

      def parse(body)
      end

      def commit(action, money, parameters)
      end

      def message_from(response)
      end

      def post_data(action, parameters = {})
      end
    end
  end
end


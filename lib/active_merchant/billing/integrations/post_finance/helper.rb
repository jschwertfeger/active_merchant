module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module PostFinance
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          include Common

          mapping :order, 'ORDERID'
          mapping :account, 'PSPID'
          mapping :amount, 'AMOUNT'
          mapping :currency, 'CURRENCY'
          mapping :language, 'LANGUAGE'

          mapping :customer,
                  :name => 'CN',
                  :email => 'EMAIL',
                  :phone => 'OWNERTELNO'

          mapping :billing_address,
                  :city => 'OWNERTOWN',
                  :address1 => 'OWNERADDRESS',
                  :zip => 'OWNERZIP',
                  :country => 'OWNERCTY'

          mapping :template_url, 'TP'
          mapping :return_url, 'CATALOGURL'
          mapping :cancel_return_url, 'CANCELURL'
          mapping :description, 'COM'

          def initialize(order, account, options={})
            @secret = options.delete(:secret)
            unless @secret
              raise ArgumentError, 'You need to provide the SHA secret as the option :secret to sign your request for PostFinance'
            end
            super
          end

          def form_fields
            @fields.merge('SHASIGN' => generate_signature(@fields))
          end
        end
      end
    end
  end
end

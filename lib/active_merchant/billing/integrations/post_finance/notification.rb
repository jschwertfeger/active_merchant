require 'bigdecimal'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module PostFinance
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          include Common

          SIGNATURE_PARAM = 'SHASIGN'

          def initialize(post, options={})
            unless options[:secret]
              raise ArgumentError, 'You need to provide the SHA secret as the option :secret to verify that the notification originated from PostFinance'
            end
            super
          end

          def complete?
            status == 'Completed'
          end

          def transaction_id
            params['PAYID']
          end

          def received_at
            nil
          end

          def gross
            params['AMOUNT']
          end

          def currency
            params['CURRENCY']
          end

          def status
            case params['STATUS'].to_i
              when 5
              when 9
                'Completed'
              when 51
              when 91
                'Pending'
              else
                'Failed'
            end
          end

          def secret
            @options[:secret]
          end

          def signature
            params[SIGNATURE_PARAM]
          end

          def acknowledge
            signature == generate_signature(params.reject { |k, _| k == SIGNATURE_PARAM })
          end
        end
      end
    end
  end
end

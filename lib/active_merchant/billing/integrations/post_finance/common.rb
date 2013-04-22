require 'digest/sha2'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module PostFinance
        module Common
          def generate_signature(fields)
            string = fields.sort.reduce('') { |str, v| str += "#{v[0]}=#{v[1]}#{secret}" }
            Digest::SHA2.hexdigest(string).upcase
          end
        end
      end
    end
  end
end
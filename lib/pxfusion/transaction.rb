require "ostruct"
require "active_support/core_ext/hash/reverse_merge"

class PxFusion::Transaction < OpenStruct
  def initialize(attributes = {})
    attributes.reverse_merge!(
      username: PxFusion.username,
      password: PxFusion.password,
      currency: PxFusion.default_currency,
      return_url: PxFusion.default_return_url,
      type: 'Purchase'
    )

    super(attributes)
    [:username, :password, :currency, :amount, :type, :reference].each do |required_attribute|
      raise ArgumentError.new("Missing attribute: #{required_attribute}") if !self.send(required_attribute)
    end
  end

  def generate_session_id!
    response = PxFusion.client.call(
      :get_transaction_id,
      message: Request.get_transaction_id(self)
      ).body[:get_transaction_id_response][:get_transaction_id_result]

    self.id = response[:transaction_id]
    self.session_id = response[:session_id]

    raise "Session could not be obtained from DPS" unless id && session_id

    session_id
  end

  private

    module Request
      def self.get_transaction_id(transaction)
        # Build the hash to be sent to DPS
        # THE ORDER MATTERS
        attributes = transaction.instance_variable_get("@table")
        msg = {
          username: attributes[:username],
          password: attributes[:password],
          tranDetail: {
            amount: attributes[:amount],
            currency: attributes[:currency],
            returnUrl: attributes[:return_url],
            txnRef: attributes[:reference],
            txnType: attributes[:type]
          }
        }
      end
    end
end

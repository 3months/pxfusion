require "ostruct"
require "active_support/core_ext/hash/reverse_merge"

class PxFusion::Transaction < OpenStruct
  def initialize(attributes = {})
    attributes.reverse_merge!(
      username: PxFusion.username,
      password: PxFusion.password,
      currency: PxFusion.default_currency,
      type: 'Purchase'
    )

    super(attributes)
    [:username, :password, :currency, :amount, :type, :reference].each do |required_attribute|
      raise ArgumentError.new("Missing attribute: #{required_attribute}") if !self.send(required_attribute)
    end
  end

  def find(id)
    instantiate_from_soap!(id)
  end

  private

    def request_id!
      PxFusion.client.call(:get_transaction_id, message: Request.get_transaction_id(self))
    end


    module Request
      def self.get_transaction_id(transaction)
        attributes = transaction.instance_variable_get("@table").dup.tap do |attrs|
          attrs[:txnRef] = attrs.delete(:reference)
          attrs[:txnType] = attrs.delete(:type)
        end

        msg = {
          username: attributes.delete(:username),
          password: attributes.delete(:password),
          tranDetail: attributes
        }
      end
    end
end

require "ostruct"
require "active_support/core_ext/hash/reverse_merge"

class PxFusion::Transaction < OpenStruct
  def initialize(attributes = {})
    attributes.reverse_merge!(
      username: PxFusion.username,
      password: PxFusion.password,
      currency: PxFusion.default_currency,
      return_url: "https://test.host/",
      type: 'Purchase',
    )

    super(attributes)
    [:username, :password, :currency, :amount, :type].each do |required_attribute|
      raise ArgumentError.new("Missing attribute: #{required_attribute}") if !self.send(required_attribute)
    end

    {amount: 12, currency: 3, reference: 16, return_url: 255, type: 8}.each_pair do |attribute, length|
      next unless self.send(attribute)
      attribute_value = self.send(attribute).to_s
      given_length = attribute_value.length
      raise ArgumentError.new("PxFusion #{attribute} too long (max #{length} characters). #{attribute} given (#{given_length} characters): #{attribute_value}") if given_length > length
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

  def self.fetch(id)
    response = PxFusion.client.call(:get_transaction,message: {username: PxFusion.username, password: PxFusion.password, transactionId: id}).body
    attributes = response[:get_transaction_response][:get_transaction_result]
    raise PxFusion::Transaction::NotFound if attributes[:status].to_i == PxFusion.statuses[:not_found]

    mapped_attributes = attributes.dup
    attributes.each do |attribute, value|
      case attribute
      when :currency_name
        mapped_attributes[:currency] = attributes[:currency_name]
      when :txn_type
        mapped_attributes[:type] = attributes[:txn_type]
      when :response_text
        mapped_attributes[:response] = attributes[:response_text]
      when :merchant_reference
        mapped_attributes[:reference] = attributes[:merchant_reference]
      when :status
        mapped_attributes[:status] = attributes[:status].to_i
      end
    end

    self.new(mapped_attributes.merge(username: PxFusion.username, password: PxFusion.password))
  end

  private


    class NotFound < Exception
    end

    module Request
      def self.get_transaction_id_with_token(transaction)
        attributes = transaction.instance_variable_get("@table")

        msg = {
          username: attributes[:username],
          password: attributes[:password],
          tranDetail: {
            amount: attributes[:amount],
            currency: attributes[:currency],
            enableAddBillCard: true,
            merchantReference: attributes[:reference],
            returnUrl: attributes[:return_url],
            txnRef: attributes[:reference],
            txnType: attributes[:type]
          }
        }
      end

      def self.get_transaction_id_without_token(transaction)
        attributes = transaction.instance_variable_get("@table")

        msg = {
          username: attributes[:username],
          password: attributes[:password],
          tranDetail: {
            amount: attributes[:amount],
            currency: attributes[:currency],
            merchantReference: attributes[:reference],
            returnUrl: attributes[:return_url],
            txnRef: attributes[:reference],
            txnType: attributes[:type]
          }
        }
      end

      def self.get_transaction_id(transaction)
        # Build the hash to be sent to DPS
        # THE ORDER MATTERS
        attributes = transaction.instance_variable_get("@table")

        attributes[:token_billing] ? get_transaction_id_with_token(transaction) : get_transaction_id_without_token(transaction)
      end
    end
end

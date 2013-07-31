require "pxfusion/version"
require "pxfusion/client"
require "pxfusion/transaction"

module PxFusion
  class << self
    attr_writer :endpoint, :username, :password, :default_currency

    [:endpoint, :username, :password].each do |required_attribute|
      define_method required_attribute do
        raise "#{required_attribute} must be set" if !instance_variable_get("@#{required_attribute}")
        instance_variable_get("@#{required_attribute}")
      end
    end

    def default_currency
      @default_currency ||= "NZD"
    end

    def client
      @client ||= Client.new
    end
  end
end

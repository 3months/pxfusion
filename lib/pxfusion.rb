require "pxfusion/version"
require "pxfusion/client"
require "pxfusion/transaction"

module PxFusion
  class << self
    attr_writer :endpoint,
                :username,
                :password,
                :default_currency,
                :default_return_url,
                :logging

    [:username, :password, :default_return_url].each do |required_attribute|
      define_method required_attribute do
        raise "#{required_attribute} must be set" if !instance_variable_get("@#{required_attribute}")
        instance_variable_get("@#{required_attribute}")
      end
    end

    def endpoint
      @endpoint ||= "https://sec.paymentexpress.com/pxf/pxf.svc"
    end

    def default_currency
      @default_currency ||= "NZD"
    end

    def logging
      @logging ||= true
    end

    def client
      @client ||= Client.new
    end

    def statuses
      {
        approved: 0,
        declined: 1,
        retry: 2,
        invalid_post: 3,
        unknown: 4,
        cancelled: 5,
        not_found: 6
      }
    end
  end
end

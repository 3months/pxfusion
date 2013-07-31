require "pxfusion/version"
require "pxfusion/client"

module PxFusion
  class << self
    attr_writer :endpoint, :username, :password

    [:endpoint, :username, :password].each do |required_attribute|
      define_method required_attribute do
        raise "#{required_attribute} must be set" if !instance_variable_get("@#{required_attribute}")
        instance_variable_get("@#{required_attribute}")
      end
    end
  end
end

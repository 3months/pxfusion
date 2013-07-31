require "savon"

class PxFusion::Client < Savon::Client
  def initialize(options = {})
    super(options.merge(wsdl: "#{PxFusion.endpoint}?wsdl"))
  end
end
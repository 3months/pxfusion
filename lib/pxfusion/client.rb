require "savon"

class PxFusion::Client < Savon::Client
  def initialize(options = {})
    super(options.merge(
      wsdl: PxFusion.endpoint + "?wsdl",
      element_form_default: :qualified,
      log: false
    ))
  end
end
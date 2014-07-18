require "savon"

class PxFusion::Client < Savon::Client
  def initialize(options = {})
    super(options.merge(
      wsdl: PxFusion.endpoint.dup + "?wsdl",
      element_form_default: :qualified,
      log: PxFusion.logging,
      logger: PxFusion.logger,
      filters: [:password]
    ))
  end
end

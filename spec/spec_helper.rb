# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
require 'webmock/rspec'
require 'vcr'
require 'byebug'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<USERNAME>') { PxFusion.username }
  c.filter_sensitive_data('<PASSWORD>') { PxFusion.password }
  c.ignore_request do |request|
    URI(request.uri).query == "wsdl"
  end
end

require "pxfusion"

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.before do
    PxFusion.username = "sample"
    PxFusion.password = "sample"
    PxFusion.default_return_url = "http://pxfusion.local/test"
    PxFusion.logging = false
    PxFusion.client
  end


  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

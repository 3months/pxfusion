# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pxfusion/version'

Gem::Specification.new do |spec|
  spec.name          = "pxfusion"
  spec.version       = PxFusion::VERSION
  spec.authors       = ["Josh McArthur"]
  spec.email         = ["joshua.mcarthur@gmail.com"]
  spec.description   = %q{A Rubygem for talking to DPS's PxFusion payment product}
  spec.summary       = %q{A Rubygem for talking to DPS's PxFusion payment product}
  spec.homepage      = "https://github.com/3months/pxfusion"
  spec.license       = "GPL"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_dependency "savon"
  spec.add_dependency "activesupport"
end

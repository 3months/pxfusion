require "spec_helper"

describe PxFusion::Client do
  it { expect(described_class.superclass).to eq Savon::Client }

  describe ".initialize" do
    subject { described_class.new }
    it { expect(subject.instance_variable_get("@wsdl").document).to eq "#{PxFusion.endpoint}?wsdl" }
  end
end
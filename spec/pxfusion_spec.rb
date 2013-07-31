require "spec_helper"

describe PxFusion do
  describe "configuration" do
    [:endpoint, :username, :password].each do |attr|
      it { described_class.should respond_to :"#{attr}=" }
      it { expect { described_class.send(:"#{attr}=", nil); described_class.send(attr) }.to raise_error }
      it { expect { described_class.send(attr) }.to_not raise_error }
    end

    it { described_class.should respond_to :default_currency }
    it { described_class.default_currency.should_not be_blank }
  end

  describe ".client" do
    it { described_class.client.should be_a PxFusion::Client }
    it { c = described_class.client; described_class.client.should eq c }
  end
end

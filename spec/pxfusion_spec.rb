require "spec_helper"

describe PxFusion do
  describe "configuration" do
    [:endpoint, :username, :password, :default_return_url].each do |attr|
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

  describe ".statuses" do
    it { described_class.statuses[:approved].should eq 0 }
    it { described_class.statuses[:declined].should eq 1 }
    it { described_class.statuses[:retry].should eq 2 }
    it { described_class.statuses[:invalid_post].should eq 3 }
    it { described_class.statuses[:unknown].should eq 4 }
    it { described_class.statuses[:cancelled].should eq 5 }
    it { described_class.statuses[:not_found].should eq 6 }
  end
end

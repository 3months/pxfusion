require "spec_helper"

describe PxFusion::Transaction do
  let(:timestamp) { Time.now.to_i }

  subject { described_class.new(amount: "10.00", reference: timestamp) }

  describe ".initialize", :vcr do
    context "normal attributes passed in" do
      it { subject.amount.should eq "10.00" }
      it { subject.reference.should eq timestamp }
      it { subject.currency.should eq "NZD" }
      it { subject.id.should_not be_nil }
      it { subject.session_id.should_not be_nil }
    end

    context "missing attributes" do
      it { expect { described_class.new(amount: "10.00") }.to raise_error(ArgumentError) }
    end

    context "overriding globally-configured attributes", :vcr do
      it { described_class.new(amount: "10.00", reference: "12345", currency: "USD").currency.should eq "USD" }
    end
  end

end

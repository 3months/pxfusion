require "spec_helper"

describe PxFusion::Transaction do
  subject { described_class.new(amount: 10.00, reference: Time.now.to_i) }

  describe ".initialize" do
    context "normal attributes passed in" do
      subject { described_class.new(amount: 10.00, reference: "12345") }
      it { subject.amount.should eq 10.00 }
      it { subject.reference.should eq "12345" }
      it { subject.currency.should eq "NZD" }
    end

    context "missing attributes" do
      it { expect { described_class.new(amount: 10.00) }.to raise_error(ArgumentError) }
    end

    context "overriding globally-configured attributes" do
      subject { described_class.new(amount: 10.00, reference: "12345", currency: "USD") }
      it { subject.currency.should eq "USD" }
    end
  end

  describe ".request_id!" do
    VCR.use_cassette('get_transaction_id') do
      it { expect { subject.send(:request_id!) }.to change(subject, :id) }
    end
  end
end
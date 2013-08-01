require "spec_helper"

describe PxFusion::Transaction do
  let(:timestamp) { Time.now.to_i }

  subject(:transaction) { described_class.new(amount: "10.00", reference: timestamp) }

  describe ".initialize" do
    context "normal attributes passed in" do
      it { transaction.amount.should eq "10.00" }
      it { transaction.reference.should eq timestamp }
      it { transaction.currency.should eq "NZD" }
    end

    context "missing attributes" do
      it { expect { described_class.new(amount: "10.00") }.to raise_error(ArgumentError) }
    end

    context "overriding globally-configured attributes", :vcr do
      it { described_class.new(amount: "10.00", reference: "12345", currency: "USD").currency.should eq "USD" }
    end
  end

  describe ".generate_session_id!", :vcr do
    subject { -> { transaction.reference = Time.now.to_i;transaction.generate_session_id! } }
    it { expect { subject.call }.to change(transaction, :session_id) }
    it { expect { subject.call }.to change(transaction, :id) }
  end
end

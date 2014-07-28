require "spec_helper"

describe PxFusion::Transaction do
  let(:timestamp) { Time.now.to_i }
  let(:complete_transaction_id) { "0000010016327641e4c03879868bd001" }

  subject(:transaction) { described_class.new(amount: "10.00", reference: timestamp) }

  describe ".initialize" do
    context "normal attributes passed in" do
      it { transaction.amount.should eq "10.00" }
      it { transaction.reference.should eq timestamp }
      it { transaction.currency.should eq "NZD" }
    end

    context "missing attributes" do
      it { expect { described_class.new(reference: "Test") }.to raise_error(ArgumentError) }
    end

    context "overriding globally-configured attributes", :vcr do
      it { described_class.new(amount: "10.00", reference: "12345", currency: "USD").currency.should eq "USD" }
    end

    context "token billing" do
      it { described_class.new(amount: "10.00", reference: "12345", token_billing: true).token_billing.should be_truthy }
    end
  end

  describe ".generate_session_id!", :vcr do
    subject { -> { transaction.reference = Time.now.to_i;transaction.generate_session_id! } }
    it { expect { subject.call }.to change(transaction, :session_id) }
    it { expect { subject.call }.to change(transaction, :id) }
  end

  describe ".fetch" do
    context "transaction is complete", :vcr do
      subject { PxFusion::Transaction.fetch(complete_transaction_id) }
      it { subject.currency.should eq "NZD" }
      it { subject.amount.should eq "1.00" }
      it { subject.status.should eq PxFusion.statuses[:approved] }
      it { subject.response.should_not be_empty }
    end

    context "transaction is incomplete", :vcr do
      subject { transaction.reference = Time.now.to_i; transaction.generate_session_id! }
      it { expect { PxFusion::Transaction.fetch(subject) }.to raise_error PxFusion::Transaction::NotFound }
    end

    context "transaction does not exist", :vcr do
      it { expect { PxFusion::Transaction.fetch("1234") }.to raise_error(PxFusion::Transaction::NotFound) }
    end
  end
end

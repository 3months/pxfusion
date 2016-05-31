require "spec_helper"

describe PxFusion::Transaction do
  let(:timestamp) { Time.now.to_i }
  let(:complete_transaction_id) { "0000010016327641e4c03879868bd001" }

  subject(:transaction) { described_class.new(amount: "10.00", reference: timestamp) }

  describe ".initialize" do
    context "normal attributes passed in" do
      it { expect(transaction.amount).to eq "10.00" }
      it { expect(transaction.reference).to eq timestamp }
      it { expect(transaction.currency).to eq "NZD" }
    end

    context "missing attributes" do
      it { expect { described_class.new(reference: "Test") }.to raise_error(ArgumentError) }
    end

    context "overriding globally-configured attributes", :vcr do
      subject { described_class.new(amount: "10.00", reference: "12345", currency: "USD") }
      it { expect(subject.currency).to eq "USD" }
    end

    context "token billing" do
      subject { described_class.new(amount: "10.00", reference: "12345", token_billing: true) }
      it { expect(subject.token_billing).to be_truthy }
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
      it { expect(subject.currency).to eq "NZD" }
      it { expect(subject.amount).to eq "1.00" }
      it { expect(subject.status).to eq PxFusion.statuses[:approved] }
      it { expect(subject.response).to_not be_empty }
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

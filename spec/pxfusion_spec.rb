require "spec_helper"

describe PxFusion do
  describe "configuration" do
    [:username, :password].each do |attr|
      it { expect(described_class).to respond_to :"#{attr}=" }
      it { expect { described_class.send(:"#{attr}=", nil); described_class.send(attr) }.to raise_error }
      it { expect { described_class.send(attr) }.to_not raise_error }
    end

    it { expect(described_class).to respond_to :default_currency }
    it { expect(described_class.default_currency).to_not be_blank }
    it { expect(described_class.endpoint).to eq "https://sec.paymentexpress.com/pxf/pxf.svc" }
    it { expect(described_class.form_endpoint).to eq "https://sec.paymentexpress.com/pxmi3/pxfusionauth" }
    it { expect(described_class).to respond_to :default_return_url }
    it { expect(described_class).to respond_to :default_return_url= }
  end

  describe ".client" do
    it { expect(described_class.client).to be_a PxFusion::Client }
  end

  describe ".statuses" do
    it { expect(described_class.statuses[:approved]).to eq 0 }
    it { expect(described_class.statuses[:declined]).to eq 1 }
    it { expect(described_class.statuses[:retry]).to eq 2 }
    it { expect(described_class.statuses[:invalid_post]).to eq 3 }
    it { expect(described_class.statuses[:unknown]).to eq 4 }
    it { expect(described_class.statuses[:cancelled]).to eq 5 }
    it { expect(described_class.statuses[:not_found]).to eq 6 }
  end
end

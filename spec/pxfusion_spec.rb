require "spec_helper"

describe PxFusion do
  describe "configuration" do
    [:endpoint, :username, :password].each do |attr|
      it { described_class.should respond_to :"#{attr}=" }
      it { expect { described_class.username }.to raise_error }
      it { expect { described_class.send(:"#{attr}=", "Test"); described_class.send(attr) }.to_not raise_error }
    end
  end
end

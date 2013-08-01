describe "Rails engine" do
  context "Rails is installed" do
    before do
      class ::Rails
        class Engine
          def self.isolate_namespace(ns)
          end
        end
      end
    end

    it "loads the Rails engine class" do
      require "pxfusion"
      PxFusion::Engine.superclass.should eq Rails::Engine
    end
  end

  context "Rails is not installed" do
    before do
      Object.send(:remove_const, :PxFusion)
      Object.stub(:defined?).with(Rails).and_return(false)
    end

    it "does not load the Rails engine class" do
      require "pxfusion"
      defined?(PxFusion::Engine).should be_false
    end
  end
end

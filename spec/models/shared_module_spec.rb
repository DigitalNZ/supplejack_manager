require "spec_helper"

describe SharedModule do

  describe ".find_by_name" do
    let!(:shared_module) { FactoryGirl.create(:shared_module, name: "Copyright") }

    it "finds the shared module by name" do
      SharedModule.find_by_name("Copyright").should eq shared_module
    end

    it "returns nil when it doesn't find a shared module" do
      SharedModule.find_by_name("Mapping").should be_nil
    end
  end

  context "file paths" do
    let(:shared_module) { FactoryGirl.build(:shared_module, name: "Copyright Rules") }

    describe "#file_name" do
      it "returns a correct file_name" do
        shared_module.file_name.should eq "copyright_rules.rb"
      end
    end

    describe "path" do
      it "returns the file path relative to the repository root dir" do
        shared_module.path.should eq "shared_modules/copyright_rules.rb"
      end
    end
  end
end
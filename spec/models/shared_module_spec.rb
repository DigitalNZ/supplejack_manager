require "spec_helper"

describe SharedModule do

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
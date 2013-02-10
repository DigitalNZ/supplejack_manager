require "spec_helper"

describe Snippet do

  describe ".find_by_name" do
    let!(:snippet) { FactoryGirl.create(:snippet, name: "Copyright") }

    it "finds the snippet by name" do
      Snippet.find_by_name("Copyright").should eq snippet
    end

    it "returns nil when it doesn't find the snippet" do
      Snippet.find_by_name("Mapping").should be_nil
    end
  end

  context "file paths" do
    let(:snippet) { FactoryGirl.build(:snippet, name: "Copyright Rules") }

    describe "#file_name" do
      it "returns a correct file_name" do
        snippet.file_name.should eq "copyright_rules.rb"
      end
    end

    describe "path" do
      it "returns the file path relative to the repository root dir" do
        snippet.path.should eq "snippets/copyright_rules.rb"
      end
    end
  end
end
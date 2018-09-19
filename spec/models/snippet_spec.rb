require "rails_helper"

describe Snippet do

  context "scopes" do
    context "#default_scope" do
      it "returns snippets that are not soft deleted" do
        create_list :snippet, 2
        create :snippet, :deleted

        Snippet.all.each do |snippet|
          expect(snippet.deleted_at).to be nil
        end

        expect(Snippet.count).to be 2
      end
    end
  end

  describe ".find_by_name" do

    let!(:snippet) { create(:snippet, name: "Copyright") }

    it "finds the snippet by name" do
      expect(Snippet).to receive(:where).with( { name: "Copyright" }) { [snippet] }
      Snippet.find_by_name("Copyright", :staging)
    end

    it "returns the current version of the snippet" do
      allow(Snippet).to receive(:where) { [snippet] }
      expect(snippet).to receive(:current_version).with(:staging)
      Snippet.find_by_name("Copyright", :staging)
    end

    it "returns nil when it doesn't find the snippet" do
      expect(Snippet.find_by_name("Mapping", :staging)).to be_nil
    end

  end

  context "file paths" do

    let(:snippet) { build(:snippet, name: "Copyright Rules") }

    describe "#file_name" do
      it "returns a correct file_name" do
        expect(snippet.file_name).to eq "copyright_rules.rb"
      end
    end

    describe "path" do
      it "returns the file path relative to the repository root dir" do
        expect(snippet.path).to eq "snippets/copyright_rules.rb"
      end
    end

  end
end

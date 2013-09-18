require 'spec_helper'

describe Versioned do
  before do
    Partner.any_instance.stub(:update_apis)
    Source.any_instance.stub(:update_apis)
  end

  let(:parser) { FactoryGirl.create(:parser) }

  describe "#last_edited_by" do
    it "should return the last edited by" do
      parser.stub(:versions) { [mock(:version, user: mock(:user, name: "bill"))] }
      parser.last_edited_by.should eq "bill"
    end

    it "handles parsers with no versions" do
      parser.stub(:versions) { [] }
      parser.last_edited_by.should be_nil
    end
  end

  describe "current_version" do
    before(:each) do
      parser.attributes = {tags: ["production"], content: "Hi 1"}
      parser.save
      parser.attributes = {tags: nil, content: "Hi 2"}
      parser.save
      parser.reload
    end

    context "production environment" do
      it "returns the most recent version tagged with production" do
        parser.current_version(:production).should eq parser.versions[1]
      end
    end

    context "test environment" do
      it "returns the most recent version regardless of tags" do
        parser.current_version(:test).should eq parser.versions[2]
      end
    end
  end

  describe "#save_with_version" do
    let(:parser) { FactoryGirl.build(:parser, strategy: "json", name: "Natlib") }

    context "valid parser" do
      before(:each) do
        parser.save
        @version = parser.versions.first
      end

      context "content has not changed" do

        it "it should not trigger #save_with_version after save" do
          parser.should_not_receive(:save_with_version)
          parser.save
        end

      end

      context "content has changed" do
        before do
          parser.content = "New parser content"
        end

        it "it should #save_with_version after save" do
          parser.should_receive(:save_with_version)
          parser.save
        end
      end

      it "creates a new parser version" do
        parser.versions.size.should eq 1
      end

      it "copies the contents" do
        @version.content.should eq parser.content
      end

      it "generates the version number" do
        @version.version.should eq 1
      end
    end

    context "invalid parser" do
      it "doesnt generate a new version when saving fails" do
        parser.name = nil
        parser.save.should be_false
        parser.versions.should be_empty
      end
    end
  end

  describe "#find_version" do
    it "finds the version" do
      parser.save
      version = parser.versions.first
      parser.find_version(version.id).should eq version
    end
  end

end

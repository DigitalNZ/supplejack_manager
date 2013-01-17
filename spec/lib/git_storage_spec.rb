require "spec_helper"

class TestStorage < GitStorage
end

describe GitStorage do
  let(:storage) { TestStorage.new("test/copyright.rb", "Some data") }

  describe ".build" do
    it "should initialize a unsaved storage" do
      sm = TestStorage.build(path: "test/license.rb", data: "class License; end")
      sm.name.should eq "license.rb"
      sm.data.should eq "class License; end"
      sm.persisted?.should be_false
    end

    it "initializes a empty storage" do
      TestStorage.build.should be_a TestStorage
    end
  end

  describe ".find" do
    let(:blob) { mock(:blob, name: "license.rb", data: "") }

    before(:each) do
      THE_REPO.stub_chain(:tree, :/).with("test/license.rb") { blob }
    end

    it "should find a storage by path" do
      sm = TestStorage.find("test/license.rb")
      sm.should be_a(TestStorage)
      sm.path.should eq "test/license.rb"
    end
  end

  describe ".all" do
    let(:tree1) { mock(:tree, contents: [mock(:blob, name: "license.rb", data: "")]) }
    let(:tree2) { mock(:tree, contents: [mock(:blob, name: "europeana.rb", data: "")]) }

    before(:each) do
      THE_REPO.stub_chain(:tree, :/).with("test") { tree1 }
      THE_REPO.stub_chain(:tree, :/).with("json") { tree2 }
    end

    it "should return all storage objects" do
      storages = TestStorage.all("test")
      storages.size.should eq 1
      storages.first.should be_a(TestStorage)
      storages.first.name.should eq "license.rb"
      storages.first.persisted?.should be_true
    end

    it "returns objects from multiple directories" do
      storages = TestStorage.all(["test", "json"])
      storages.size.should eq 2
    end
  end

  context "validations" do
    it "should not be valid without path" do
      storage.path = nil
      storage.should_not be_valid
    end

    it "should not be valid without data" do
      storage.data = nil
      storage.should_not be_valid
    end

    it "should be valid with a valid name" do
      storage.path = "test/copyright_mapping.rb"
      storage.should be_valid
    end

    it "should not be valid with a invalid name" do
      storage.path = "test/copyright-mapping.rb"
      storage.should_not be_valid
    end
  end
  
  describe "#initialize" do
    it "should set the path" do
      storage.path.should eq "test/copyright.rb"
    end

    it "should set the data" do
      storage.data.should eq "Some data"
    end

    it "should be persisted by default" do
      storage.persisted?.should be_true
    end
  end

  describe "#save" do
    context "valid storage" do
      before(:each) do
        THE_REPO.stub(:add).with("test/copyright.rb", "Some data")
        THE_REPO.stub(:commit).with("New config", nil)
        storage.instance_variable_set("@persisted", false)
      end
      
      it "commits with the new file contents" do
        THE_REPO.should_receive(:add).with("test/copyright.rb", "Some data")
        THE_REPO.should_receive(:commit).with("New config", nil)
        storage.save("New config")
      end

      it "sets the record as persisted" do
        storage.save("New config")
        storage.persisted?.should be_true
      end
    end

    it "returns false when invalid" do
      storage.stub(:valid?) { false }
      storage.save.should be_false
    end
  end

  describe "#update_attributes" do
    let(:user) { mock(:user) }

    it "updates the data" do
      storage.should_receive("data=").with("new data")
      storage.should_receive(:save)
      storage.update_attributes({data: "new data"}, nil)
    end

    it "adds a message to the commit" do
      storage.should_receive(:save).with("Testing", nil)
      storage.update_attributes({data: "new data", message: "Testing"}, nil)
    end

    it "sends the commit author" do
      storage.should_receive(:save).with("Testing", user)
      storage.update_attributes({data: "new data", message: "Testing"}, user)
    end
  end
end
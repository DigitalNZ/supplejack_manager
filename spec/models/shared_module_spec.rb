require "spec_helper"

describe SharedModule do

  describe ".build" do
    it "initializes a new shared module" do
      sm = SharedModule.build(name: "license.rb", data: "")
      sm.path.should eq "shared_modules/license.rb"
      sm.name.should eq "license.rb"
    end
  end

  describe ".find" do
    let(:blob) { mock(:blob, name: "license.rb", data: "") }

    before(:each) do
      THE_REPO.stub_chain(:tree, :/).with("shared_modules/license.rb") { blob }
    end

    it "should find a shared module by name" do
      sm = SharedModule.find("license.rb")
      sm.should be_a(SharedModule)
      sm.name.should eq "license.rb"
    end
  end

  describe ".all" do
    let(:tree) { mock(:tree, contents: [mock(:blob, name: "license.rb", data: "")]) }

    before(:each) do
      THE_REPO.stub_chain(:tree, :/).with("shared_modules") { tree }
    end

    it "should return all shared modules" do
      shared_modules = SharedModule.all
      shared_modules.size.should eq 1
      shared_modules.first.should be_a(SharedModule)
      shared_modules.first.name.should eq "license.rb"
      shared_modules.first.persisted?.should be_true
    end
  end
end
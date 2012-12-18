require 'spec_helper'

describe Parser do

  describe ".repository" do
    let(:repo) { mock(:repo) }

    it "should initialize a new repository" do
      Grit::Repo.should_receive(:new).with("/test") { repo }
      Parser.repository.should eq repo
    end
  end

  describe ".head" do
    let(:commit) { mock(:commit) }
    let(:repo) { mock(:repo, commits: [commit]) }

    before { Parser.stub(:repository) {repo} }

    it "it returns the latest commit object" do
      Parser.head.should eq commit
    end
  end

  describe ".tree" do
    let(:tree) { mock(:tree) }
    let(:head) { mock(:head, tree: tree) }

    before { Parser.stub(:head) {head} }

    it "returns the tree from head" do
      Parser.tree.should eq tree
    end
  end

  describe ".find" do
    let(:tree) { mock(:tree) }
    let(:blob) { mock(:blob).as_null_object }

    before do 
      Parser.stub(:tree) { tree }
      Parser.tree.stub(:/) { blob }
    end

    it "finds the file by it's path" do
      Parser.tree.should_receive(:/).with("xml/natlib_pages.rb") { blob }
      Parser.find("xml/natlib_pages.rb")
    end

    it "initializes a new parser" do
      Parser.find("xml/natlib_pages.rb").should be_a Parser
    end

    it "initializes a parser with blob and strategy" do
      Parser.should_receive(:new).with(blob, "xml")
      Parser.find("xml/natlib_pages.rb")
    end
  end

  describe ".all" do
    let(:ds_store) { mock(:blob, name: ".DS_STORE") }
    let(:europeana) { mock(:blob, name: "europeana.rb") }
    let(:json) { mock(:tree, name: "json", contents: [europeana]) }

    before do
      Parser.stub(:tree) { mock(:tree, contents: [ds_store, json]) }
    end

    it "returns all the parsers" do
      Parser.should_receive(:new).with(europeana, "json")
      Parser.all
    end
  end
end

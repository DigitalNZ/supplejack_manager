require "spec_helper"

describe Repo do

  let(:repo) { Repo.new }

  describe "initialize" do
    let(:grit_repo) { mock(:grit_repo) }

    it "should initialize a new repository" do
      Grit::Repo.should_receive(:init_bare).with(ENV["PARSER_GIT_REPO_PATH"]) { grit_repo }
      Repo.new.grit_repo.should eq grit_repo
    end
  end

  describe "#index" do
    let(:index) { mock(:index).as_null_object }
    let(:grit_repo) { mock(:grit_repo, index: index) }

    before do 
      repo.stub(:head) { mock(:head, tree: mock(:tree, id: "1")) }
      repo.stub(:grit_repo) { grit_repo }
    end

    it "should return the current index" do
      repo.index.should eq index
    end
  end

  describe "#head" do
    let(:commit) { mock(:commit) }
    let(:grit_repo) { mock(:repo, commits: [commit]) }

    before { repo.stub(:grit_repo) { grit_repo} }

    it "it returns the latest commit object" do
      repo.head.should eq commit
    end
  end

  describe "#tree" do
    let(:tree) { mock(:tree) }
    let(:head) { mock(:head, tree: tree) }

    before { repo.stub(:head) { head } }

    it "returns the tree from head" do
      repo.tree.should eq tree
    end
  end
end
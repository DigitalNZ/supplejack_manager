require "spec_helper"

describe Previewer do

  let(:parser) { mock(:parser, name: "europeana.rb", strategy: "json") }
  let(:previewer) { Previewer.new(parser, "Data") }

  class Europeana
    def self.records(options={})
      []
    end
  end
  
  describe "#path" do
    it "builds a absolute path to the temp file" do
      previewer.path.should eq "#{Rails.root.to_s}/tmp/parsers/json/europeana.rb"
    end

    it "memoizes the path" do
      parser.should_receive(:name).once
      previewer.path
      previewer.path
    end
  end

  describe "#create_tempfile" do
    it "creates a new tempfile with the path" do
      previewer.create_tempfile
      File.read(previewer.path).should eq "Data"
    end
  end

  describe "#klass" do
    it "returns the class singleton" do
      previewer.klass.should eq Europeana
    end
  end

  describe "#record" do
    let(:record) { mock(:record) }

    before do
      Europeana.stub(:records) { [record] }
    end

    it "creates the tempfile" do
      previewer.should_receive(:create_tempfile)
      previewer.record
    end

    it "loads the file" do
      previewer.should_receive(:load).with(previewer.path)
      previewer.record
    end

    it "returns the first record" do
      Europeana.should_receive(:records).with({limit: 1}) { [record] }
      previewer.record.should eq record
    end
  end

  describe "#record?" do
    let(:record) { mock(:record) }

    before do
      Europeana.stub(:records) { [] }
    end

    it "returns false" do
      previewer.record?.should be_false
    end

    it "returns true" do
      Europeana.stub(:records) { [record] }
      previewer.record?.should be_true
    end
  end

  describe "#attributes_json" do
    let(:record) { mock(:record, attributes: {title: "Json!"}) }

    it "returns the json in a pretty format" do
      previewer.stub(:record) { record }
      previewer.attributes_json.should eq JSON.pretty_generate({title: "Json!"})
    end
  end

  describe "#attributes_output" do
    let(:attributes_json) { JSON.pretty_generate({title: "Json!"}) }

    before do
      previewer.stub(:attributes_json) { attributes_json }
    end

    it "returns highlighted json" do
      output = %q{{\n  <span class=\"key\"><span class=\"delimiter\">&quot;</span><span class=\"content\">title</span><span class=\"delimiter\">&quot;</span></span>: <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">Json!</span><span class=\"delimiter\">&quot;</span></span>\n}}
      previewer.attributes_output.should match(output)
    end
  end

  describe "#errors_json" do
    let(:record) { mock(:record, errors: {title: "Invalid!"}) }

    before do
      previewer.stub(:record) { record }
    end

    it "returns the json in a pretty format" do
      previewer.errors_json.should eq JSON.pretty_generate({title: "Invalid!"})
    end

    it "returns nil when there are no errors" do
      record.stub(:errors) { {} }
      previewer.errors_json.should be_nil
    end
  end

  describe "#errors_output" do
    let(:errors_json) { JSON.pretty_generate({title: "Invalid!"}) }

    before do
      previewer.stub(:errors?) { true }
      previewer.stub(:errors_json) { errors_json }
    end

    it "returns highlighted json" do
      output = %q{{\n  <span class=\"key\"><span class=\"delimiter\">&quot;</span><span class=\"content\">title</span><span class=\"delimiter\">&quot;</span></span>: <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">Invalid!</span><span class=\"delimiter\">&quot;</span></span>\n}}
      previewer.errors_output.should match(output)
    end

    it "returns nil when there are no errors" do
      previewer.stub(:errors?) { false }
      previewer.errors_output.should be_nil
    end
  end

  describe "#errors?" do
    let(:record) { mock(:record, errors: {}) }

    before { previewer.stub(:record) { record } }

    it "returns false when there are no errors" do
      previewer.errors?.should be_false
    end

    it "returns true when there are errors" do
      record.stub(:errors) { {title: "Invalid"} }
      previewer.errors?.should be_true
    end
  end


end

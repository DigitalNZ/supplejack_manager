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

  describe "#pretty_json" do
    let(:record) { mock(:record, attributes: {title: "Json!"}) }

    it "returns the json in a pretty format" do
      previewer.stub(:record) { record }
      previewer.pretty_json.should eq JSON.pretty_generate({title: "Json!"})
    end
  end

  describe "#pretty_output" do
    let(:pretty_json) { JSON.pretty_generate({title: "Json!"}) }

    before do
      previewer.stub(:pretty_json) { pretty_json }
    end

    it "returns highlighted json" do
      output = %q{{\n  <span class=\"key\"><span class=\"delimiter\">&quot;</span><span class=\"content\">title</span><span class=\"delimiter\">&quot;</span></span>: <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">Json!</span><span class=\"delimiter\">&quot;</span></span>\n}}
      previewer.pretty_output.should match(output)
    end
  end


end

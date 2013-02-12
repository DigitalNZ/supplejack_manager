require "spec_helper"

describe Previewer do

  let(:parser) { Parser.new(name: "Europeana", strategy: "json", content: nil) }
  let(:previewer) { Previewer.new(parser, "Data") }

  class Europeana
    def self.records(options={}); [];end
    def self.clear_definitions; end
    def self.environment=(env); end
  end

  describe "#initialize" do
    it "updates the parser content" do
      previewer.parser.content.should eq "Data"
    end

    it "initializes a ParserLoader" do
      previewer.loader.should be_a(ParserLoader)
    end
  end

  describe "load_record" do
    let(:record) { mock(:record) }
    let(:loader) { mock(:loader, parser_class: Europeana, loaded?: true) }

    before(:each) do
      previewer.stub(:loader) { loader }
      Europeana.stub(:records) { [record] }
    end

    it "loads one record" do
      Europeana.should_receive(:records).with({limit: 1}) { [record] }
      previewer.load_record.should eq record
    end

    it "rescues from any error" do
      Europeana.stub(:records).and_raise(StandardError.new("Hi"))
      previewer.load_record.should be_nil
      previewer.fetch_error.should eq "Hi"
    end

    it "returns the third record" do
      previewer = Previewer.new(parser, "Data", 2)
      record3 = mock(:record, id: 3)
      Europeana.stub(:records) { [record, record, record3] }
      previewer.load_record.should eq record3
    end
  end

  describe "#record" do
    let(:record) { mock(:record).as_null_object }
    let(:loader) { mock(:loader, parser_class: Europeana, loaded?: true) }

    before do
      previewer.stub(:loader) { loader }
      Europeana.stub(:records) { [record] }
    end

    it "loads the parser file" do
      loader.should_receive(:loaded?)
      previewer.record
    end

    it "returns the first record" do
      Europeana.should_receive(:records).with({limit: 1}) { [record] }
      previewer.record.should eq record
    end
  end

  describe "#record?" do
    let(:record) { mock(:record).as_null_object }

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

    it "sets the syntax error" do
      loader = mock(:loader, loaded?: false, syntax_error: "Error")
      previewer.stub(:loader) { loader }
      previewer.record?.should be_false
      previewer.syntax_error.should eq "Error"
    end
  end

  describe "#attributes_json" do
    let(:record) { mock(:record, attributes: {title: "Json!"}).as_null_object }

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

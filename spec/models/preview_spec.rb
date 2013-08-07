require "spec_helper"

describe Preview do

  let(:preview) { Preview.new }

  @preview  = { :preview => { :id => 1 } }.to_json

  ActiveResource::HttpMock.respond_to do |mock|
    mock.post "/previews.json", {"Authorization" => "Basic MTIzNDU6", "Content-Type" => "application/json"}, @preview 
  end

  describe "#api_record_json" do

    before { preview.stub(:api_record) { '{"title":"Json!"}' } }
    
    it "returns the json in a pretty format" do
      preview.api_record_json.should eq JSON.pretty_generate({title: "Json!"})
    end
  end

  describe "#api_record_output" do
    let(:attributes_json) { JSON.pretty_generate({title: "Json!"}) }

    before do
      preview.stub(:api_record_json) { attributes_json }
    end

    it "returns highlighted json" do
      output = %q{{\n  <span class=\"key\"><span class=\"delimiter\">&quot;</span><span class=\"content\">title</span><span class=\"delimiter\">&quot;</span></span>: <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">Json!</span><span class=\"delimiter\">&quot;</span></span>\n}}
      preview.api_record_output.should match(output)
    end
  end

  describe "harvested_attributes_json" do

    before { preview.stub(:harvested_attributes) { '{"title": "Json!"}' } }

    it "returns the json in a pretty format" do
      preview.send(:harvested_attributes_json).should eq JSON.pretty_generate({title: "Json!"})
    end
  end

  describe "#harvested_attributes_output" do
    let(:attributes_json) { JSON.pretty_generate({title: "Json!"}) }

    before do
      preview.stub(:harvested_attributes_json) { attributes_json }
    end

    it "returns highlighted json" do
      output = %q{{\n  <span class=\"key\"><span class=\"delimiter\">&quot;</span><span class=\"content\">title</span><span class=\"delimiter\">&quot;</span></span>: <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">Json!</span><span class=\"delimiter\">&quot;</span></span>\n}}
      preview.harvested_attributes_output.should match(output)
    end
  end

  describe "#field_errors?" do

    it "returns false when there are no field_errors" do
      preview.stub(:field_errors)
      preview.field_errors?.should be_false
    end

    it "returns true when there are field_errors" do
      preview.stub(:field_errors) {'{"title":"Invalid"}'} 
      preview.field_errors?.should be_true
    end
  end

  describe "#field_errors_output" do
    let(:field_errors_json) { JSON.pretty_generate({title: "Invalid!"}) }

    before do
      preview.stub(:field_errors?) { true }
      preview.stub(:field_errors_json) { field_errors_json }
    end

    it "returns highlighted json" do
      output = %q{{\n  <span class=\"key\"><span class=\"delimiter\">&quot;</span><span class=\"content\">title</span><span class=\"delimiter\">&quot;</span></span>: <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">Invalid!</span><span class=\"delimiter\">&quot;</span></span>\n}}
      preview.field_errors_output.should match(output)
    end

    it "returns nil when there are no field_errors" do
      preview.stub(:field_errors?) { false }
      preview.field_errors_output.should be_nil
    end
  end

  describe "#validation_errors?" do
    it "returns false when there are no validation_errors" do
      preview.stub(:validation_errors)
      preview.validation_errors?.should be_false
    end

    it "returns true when there are validation_errors" do
      preview.stub(:validation_errors) { '{"title":"Invalid"}' }
      preview.validation_errors?.should be_true
    end
  end

  describe "#deletable?" do
    it "returns true if deletable is true in the preview hash" do
      preview.stub(:deletable) { true }
      preview.deletable?.should be_true
    end

    it "returns false if deletable is not true" do
      preview.stub(:deletable) { false }
      preview.deletable?.should be_false
    end
  end

  describe "#raw_output" do

    before { preview.stub(:raw_data) }

    it "should call pretty_xml_output when format is xml" do
      preview.format = "xml"
      preview.should_receive(:pretty_xml_output).and_call_original
      preview.raw_output
    end

    it "should call pretty_json_output when format is not xml" do
      preview.format = "json"
      preview.should_receive(:pretty_json_output) {}
      preview.raw_output
    end
  end

  describe "#pretty_xml_output" do
    it "returns the raw data" do
      preview.stub(:raw_data) { "I am raw!" }
      preview.pretty_xml_output.should eq "I am raw!"
    end
  end

  describe "pretty_json_output" do

    before { preview.stub(:raw_data) { '{"title": "Json!"}' } }

    it "returns the json in a pretty format" do
      preview.send(:pretty_json_output).should eq JSON.pretty_generate({title: "Json!"})
    end
  end

  describe "#field_errors_json" do
    it "returns the json in a pretty format" do
      preview.stub(:field_errors) { '{"title":"WRONG!"}' }
      preview.field_errors_json.should eq JSON.pretty_generate({title: "WRONG!"})
    end

    it "returns nil when there are no field_errors" do
      preview.stub(:field_errors)
      preview.field_errors_json.should be_nil
    end
  end
end
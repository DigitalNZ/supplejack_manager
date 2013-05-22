require "spec_helper"

describe Previewer do

  let(:parser) { Parser.new(name: "Europeana", strategy: "json", content: "class Europeana < HarvesterCore::Json::Base; end") }
  let(:previewer) { Previewer.new(parser, "Data", "user123") }

  describe "#preview" do
    
    let(:preview) { mock(:preview) }

    before { JSON.stub(:parse) {{}} }

    it "requests a preview object from the worker" do
      RestClient.should_receive(:post).with("#{ENV["WORKER_HOST"]}/previews", {preview: 
        { parser_code: "Data", 
          parser_id: parser.id, 
          index: 0, 
          user_id: "user123"}})
      previewer.send(:preview)    
    end

    it "store the response as json in @preview" do
      RestClient.stub(:post) { preview }
      JSON.should_receive(:parse).with(preview) { {json: "JSON!"} }
      previewer.send(:preview)
      previewer.instance_variable_get(:@preview).should eq({json: "JSON!"})
    end

    it "should memoize the response" do
      RestClient.should_receive(:post).once { preview }
      previewer.send(:preview)
      previewer.send(:preview)
    end
  end


  describe "#harvest_job" do
    let(:harvest_job) { mock(:harvest_job) }

    before(:each) do
      previewer.stub(:preview) { {'harvest_job_id' => '123'} }  
    end

    it "finds the harvest job from the preview" do
      HarvestJob.should_receive(:find).with('123') { harvest_job }
      previewer.harvest_job.should eq harvest_job
    end

    it "only finds harvest job once" do
      HarvestJob.should_receive(:find).once { harvest_job }
      previewer.harvest_job
      previewer.harvest_job
    end
  end

  describe "#harvest_failure" do
    let(:harvest_job) { mock(:harvest_job, harvest_failure: mock(:harvest_failure)) }

    before { previewer.stub(:preview) { { errors: {harvest_failure: {exception_class: "Exception"}}} } }

    it "returns the harvest_failure of the preview object" do
      previewer.harvest_failure.should eq({exception_class: "Exception"}) 
    end
  end

  describe "#record?" do
    it "returns false if there were no records processed" do
      previewer.stub(:harvest_job) {mock(:harvest_job, records_count: 0)}
      previewer.record?.should be_false
    end

    it "returns true if there was records precessed" do
      previewer.stub(:harvest_job) {mock(:harvest_job, records_count: 1)}
      previewer.record?.should be_true
    end
  end

  describe "raw_data?" do
    let(:document) { mock(:document).as_null_object }
    let(:record) { mock(:record, document: document) }

    it "returns true when the raw_data is available" do
      previewer.stub(:preview) { {raw_data: "Raw data!"} }
      previewer.raw_data?.should be_true
    end

    it "returns false when the raw_data is nil" do
      previewer.stub(:preview) { {raw_data: nil} }
      previewer.raw_data?.should be_false 
    end
  end

  describe "#api_record_output" do
    let(:attributes_json) { JSON.pretty_generate({title: "Json!"}) }

    before do
      previewer.stub(:api_record_json) { attributes_json }
    end

    it "returns highlighted json" do
      output = %q{{\n  <span class=\"key\"><span class=\"delimiter\">&quot;</span><span class=\"content\">title</span><span class=\"delimiter\">&quot;</span></span>: <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">Json!</span><span class=\"delimiter\">&quot;</span></span>\n}}
      previewer.api_record_output.should match(output)
    end
  end

  describe "#api_record_json" do
    let(:preview) { {"record" => { title: "Json!" } } }

    it "returns the json in a pretty format" do
      previewer.stub(:preview) { preview }
      previewer.send(:api_record_json).should eq JSON.pretty_generate({title: "Json!"})
    end
  end

  describe "#field_errors?" do
    before { previewer.stub(:preview) { {errors: {field_errors: {} }}} }

    it "returns false when there are no field_errors" do
      previewer.field_errors?.should be_false
    end

    it "returns true when there are field_errors" do
      previewer.stub(:preview) {{errors: { field_errors: { title: "Invalid" }}} }
      previewer.field_errors?.should be_true
    end
  end

  describe "#field_errors_output" do
    let(:field_errors_json) { JSON.pretty_generate({title: "Invalid!"}) }

    before do
      previewer.stub(:field_errors?) { true }
      previewer.stub(:field_errors_json) { field_errors_json }
    end

    it "returns highlighted json" do
      output = %q{{\n  <span class=\"key\"><span class=\"delimiter\">&quot;</span><span class=\"content\">title</span><span class=\"delimiter\">&quot;</span></span>: <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">Invalid!</span><span class=\"delimiter\">&quot;</span></span>\n}}
      previewer.field_errors_output.should match(output)
    end

    it "returns nil when there are no field_errors" do
      previewer.stub(:field_errors?) { false }
      previewer.field_errors_output.should be_nil
    end
  end

  describe "#validation_errors?" do
    it "returns false when there are no validation_errors" do
      previewer.stub(:preview) { {errors:{validation_errors:{}}} }
      previewer.validation_errors?.should be_false
    end

    it "returns true when there are validation_errors" do
      previewer.stub(:preview) { {errors:{validation_errors:{title:"Invalid"}}} }
      previewer.validation_errors?.should be_true
    end
  end

  describe "#validation_errors" do
    it "returns the validation errors" do
      previewer.stub(:preview) { {errors:{validation_errors:{title:"Invalid"}}} }
      previewer.validation_errors.should eq({title: "Invalid"})
    end
  end

  describe "#raw_output" do

    before { previewer.stub(:preview) { {raw_data: "" }} }

    it "should call pretty_xml_output when format is xml" do
      parser.stub(:xml?) { true }
      previewer.should_receive(:pretty_xml_output).and_call_original
      previewer.raw_output
    end

    it "should call pretty_json_output when format is not xml" do
      parser.stub(:xml?) { false }
      previewer.should_receive(:pretty_json_output) {}
      previewer.raw_output
    end
  end

  describe "#pretty_xml_output" do
    it "returns the raw data" do
      previewer.stub(:preview) { {raw_data: "I am raw!" } }
      previewer.pretty_xml_output.should eq "I am raw!"
    end
  end

  describe "#pretty_json_output" do
    it "pretty generates the json output" do
      previewer.stub(:preview) { {raw_data: "I am raw!" } }
      JSON.should_receive(:pretty_generate).with("I am raw!") { "I am raw! JSON" }
      previewer.pretty_json_output.should eq "I am raw! JSON"
    end
  end

  describe "#field_errors_json" do
    it "returns the json in a pretty format" do
      previewer.stub(:preview) { {errors: {field_errors: {title: "WRONG!"}}} }
      previewer.field_errors_json.should eq JSON.pretty_generate({title: "WRONG!"})
    end

    it "returns nil when there are no field_errors" do
      previewer.stub(:preview) { {errors: {field_errors: {}}} }
      previewer.field_errors_json.should be_nil
    end
  end
end
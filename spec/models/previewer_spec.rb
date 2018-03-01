require "rails_helper"

describe Previewer do

  let(:parser) { Parser.new(name: "Europeana", strategy: "json", content: "class Europeana < SupplejackCommon::Json::Base; end") }
  let(:previewer) { Previewer.new(parser, "Data", "user123") }
  let(:preview) { mock_model(Preview) }

  describe "#create_preview_job" do

    before { allow(RestClient).to receive(:post) { '{"_id": "abc123"}' } }

    it "creates a preview job" do
      expect(RestClient).to receive(:post).with("#{ENV["WORKER_HOST"]}/previews", {
        preview: {
          format: "json",
          harvest_job: {
            parser_code: "Data", 
            parser_id: parser.id,
            environment: "preview",
            index: 0,
            limit: 0 + 1,
            user_id: "user123"
          }
        }
      })
      previewer.send(:create_preview_job)
    end

    it "sets the harvest_job_id of the previewer object" do
      previewer.send(:create_preview_job)
      expect(previewer.preview_id).to eq "abc123"
    end
  end
end
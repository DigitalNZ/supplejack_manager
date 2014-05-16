# The majority of the Supplejack code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components licensed under the GPL or MIT licenses or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require "spec_helper"

describe Previewer do

  let(:parser) { Parser.new(name: "Europeana", strategy: "json", content: "class Europeana < HarvesterCore::Json::Base; end") }
  let(:previewer) { Previewer.new(parser, "Data", "user123") }
  let(:preview) { mock_model(Preview) }

  before { previewer.stub(:preview) { preview } }

  describe "#create_preview_job" do

    before { RestClient.stub(:post) { '{"_id": "abc123"}' } }

    it "creates a preview job" do
      RestClient.should_receive(:post).with("#{ENV["WORKER_HOST"]}/previews", {
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
      previewer.preview_id.should eq "abc123"
    end
  end
end
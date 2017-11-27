# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe ParserVersionsController do

  let(:parser) { instance_double(Parser, id: "1").as_null_object }
  let(:version) { instance_double(Version, id: "2").as_null_object }
  let(:user) { instance_double(User, id: "3").as_null_object }
  let(:harvest_job) { instance_double(HarvestJob).as_null_object }
  let(:enrichment_job) { instance_double(EnrichmentJob).as_null_object}

  before(:each) do
    allow(controller).to receive(:authenticate_user!) { true }
    allow(controller).to receive(:current_user) { user }
    allow(Parser).to receive(:find).with("1") { parser }
    allow(parser).to receive(:find_version) { version }
  end

  describe "GET current" do
    it "finds the current version for an environment" do
      expect(parser).to receive(:current_version).with("staging") { version }
      get :current, parser_id: 1, environment: "staging", format: "json"
      expect(assigns(:version)).to eq version
    end
  end

  describe "GET Show" do
    it "finds the parser" do
      expect(Parser).to receive(:find).with("1") { parser }
      get :show, id: 1, parser_id: 1
      expect(assigns(:parser)).to eq parser
    end

    it "finds the version" do
      expect(parser).to receive(:find_version).with("1") { version }
      get :show, id: 1, parser_id: 1
      expect(assigns(:version)).to eq version
    end

    it "initializes a harvest job with parser_id, version_id, and user" do
      expect(HarvestJob).to receive(:build).with(parser_id: "1", version_id: "2") { harvest_job }
      get :show, id: 1, parser_id: 1
      expect(assigns(:harvest_job)).to eq harvest_job
    end
  end

  describe "PUT update" do
    it "updates the version" do
      expect(version).to receive(:update_attributes).with({ 'tags' => ['staging']})
      put :update, id: 1, parser_id: 1, version: {tags: ["staging"]}
    end

    it "redirects to the version path" do
      put :update, id: 1, parser_id: 1, version: {tags: ["staging"]}
      expect(response).to redirect_to parser_parser_version_path(parser, version)
    end

    context "posting to changes app" do
      it "post to changes app" do
        expect(version).to receive(:post_changes)
        put :update, id: 1, parser_id: 1, version: { tags: ["production"] }
      end
    end
  end

  # new_enrichment
  describe "new_enrichment" do
    it "creates a new enrichment job with parser_id, version_id, user and the environment" do
      expect(EnrichmentJob).to receive(:new).with(parser_id: parser.id, version_id: version.id, user_id: user.id, environment: "staging") { enrichment_job }
      get :new_enrichment, parser_id: parser.id, id: version.id, user_id: user.id, environment: "staging", format: :js
      expect(assigns(:enrichment_job)).to eq enrichment_job
    end
  end

  describe "new_harvest" do
    it "creates a new Harvest job with with parser_id, version_id, user and the environment" do
      expect(HarvestJob).to receive(:new).with(parser_id: parser.id, version_id: version.id, user_id: user.id, environment: "staging") { harvest_job }
      get :new_harvest, parser_id: parser.id, id: version.id, user_id: user.id, environment: "staging", format: :js
      expect(assigns(:harvest_job)).to eq harvest_job
    end
  end

  describe "find_parser" do
    it "finds a parser with params[id]" do
      allow(controller).to receive(:params) { {parser_id: "1"} }
      expect(Parser).to receive(:find).with("1") { parser }
      controller.send(:find_parser)
      expect(assigns(:parser)).to eq parser
    end
  end

  describe "find_version" do
    it "finds a parser version with params[id]" do
      allow(controller).to receive(:params) { {id: "1"} }
      controller.instance_variable_set(:@parser, parser)
      expect(parser).to receive(:find_version).with("1") { version }
      controller.send(:find_version)
      expect(assigns(:version)).to eq version
    end
  end

end

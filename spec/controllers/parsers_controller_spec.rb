# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe ParsersController do
  let(:parser)  { build(:parser) }
  let(:version) { build(:version, versionable: parser) }
  let(:user)    { create(:user, :admin) }

  before(:each) do
    sign_in user
    allow(parser).to receive(:find_version) { version }
  end

  describe "GET 'index'" do
    it 'finds all the parser configurations' do
      expect(Parser).to receive(:all) { [parser] }
      get :index
      expect(assigns(:parsers)).to eq [parser]
    end
  end

  describe 'GET show' do
    it 'finds an existing parser' do
      expect(Parser).to receive(:find).with("1234") { parser }
      get :show, id: "1234"
      expect(assigns(:parser)).to eq parser
    end
  end

  describe "GET 'new'" do
    it 'initializes a new parser' do
      get :new
      expect(assigns(:parser)).to be_a_new(Parser)
    end
  end

  describe "GET 'edit'" do
    let(:job) { build(:harvest_job) }

    before(:each) do
      allow(Parser).to receive(:find) { parser }
      allow(HarvestJob).to receive(:find) { job }
    end

    it 'finds an existing parser' do
      expect(Parser).to receive(:find).with('1234') { parser }
      get :edit, id: '1234'
      expect(assigns(:parser)).to eq parser
    end

    it 'initializes a harvest_job' do
      expect(HarvestJob).to receive(:from_parser).with(parser, user) { job }
      get :edit, id: '1234'
      expect(assigns(:harvest_job)).to eq job
    end
  end

  describe "GET 'create'" do
    before do
      allow(Parser).to receive(:new) { parser }
    end

    it 'initializes a new parser' do
      expect(Parser).to receive(:new).with({'name' => 'Tepapa'}) { parser }
      post :create, parser: { name: 'Tepapa' }
    end

    it "saves the parser" do
      expect(parser).to receive(:save)
      post :create, parser: { name: 'Tepapa' }
    end

    context 'valid parser' do
      it 'redirects to the edit page' do
        post :create, parser: { name: 'Tepapa' }
        expect(response.status).to eq 302
      end
    end

    context "invalid parser" do
      before { allow(parser).to receive(:save) { false } }

      it "renders the edit action" do
        post :create, parser: {name: "Tepapa"}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET 'update'" do
    before do
      allow(Parser).to receive(:find) { parser }
      allow(parser).to receive(:update_attributes) { true }
    end

    it "finds an existing parser " do
      expect(Parser).to receive(:find).with('1234') { parser }
      put :update, id: '1234', parser: { name: '' }
      expect(assigns(:parser)).to eq parser
    end

    it "updates the parser attributes" do
      expect(parser).to receive('attributes=').with({'name' => 'Tepapa'})
      put :update, id: '1234', parser: { name: 'Tepapa' }
    end

    it 'saves the parser' do
      expect(parser).to receive(:save)
      put :update, id: '1234', parser: { name: 'Tepapa' }
    end

    context 'valid parser' do
      before { allow(parser).to receive(:save) { true }}

      it 'redirects to edit page' do
        put :update, id: parser.id, parser: { name: '' }
        expect(response).to redirect_to edit_parser_path(parser.id)
      end
    end

    context 'invalid parser' do
      before { allow(parser).to receive(:save) { false }}

      it 'renders the edit action' do
        put :update, id: '1234', parser: { name: '' }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "GET 'destroy'" do
    before do
      allow(Parser).to receive(:find) { parser }
      allow(parser).to receive(:destroy) { true }
    end

    context "job not running for parser" do

      before { allow(parser).to receive(:running_jobs?) { false } }

      it "finds an existing parser " do
        expect(Parser).to receive(:find).with("1234") { parser }
        delete :destroy, id: "1234"
        expect(assigns(:parser)).to eq parser
      end

      it "destroys the parser config" do
        expect(parser).to receive(:destroy)
        delete :destroy, id: "1234"
      end
    end

    it "does not destroy if there are currently running jobs" do
      allow(parser).to receive(:running_jobs?) { true }
      expect(parser).not_to receive(:destroy)
      delete :destroy, id: "1234"
    end
  end

  describe "GET 'allow_flush'" do
    before do
      allow(Parser).to receive(:find) { parser }
      allow(parser).to receive(:allow_full_and_flush) { true }
      allow(parser).to receive(:save) { true }
    end

    it 'sets the allow_full_and_flush to true' do
      get :allow_flush, id: parser.id, params: { allow: true }
      expect(assigns(:parser).allow_full_and_flush).to be true
    end
  end

end

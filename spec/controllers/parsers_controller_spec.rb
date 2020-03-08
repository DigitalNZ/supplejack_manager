# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParsersController do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  let(:source)  { create(:source) }
  let(:parser)  { create(:parser, source_id: source) }
  let(:user)    { create(:user, :admin) }
  let(:version) { create(:version, versionable: parser, user: user) }

  before(:each) do
    sign_in user
    allow(parser).to receive(:find_version) { version }
  end

  describe "GET 'index'" do
    it 'returns a 200 status code' do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe "GET 'datatable'" do
    before do
      # GET parameters from datatable are too complex
      # so it is stubbed
      allow_any_instance_of(ParsersController).to receive(:datatable_params).and_return({
              search:    '',
              start:     0,
              per_page:  20,
              order_by:  'updated_at',
              direction: 'desc'
            })
    end

    it 'returns a 200 status code' do
      get :datatable
      expect(response).to have_http_status(200)
    end

    it 'returns JSON' do
      get :datatable
      expect(response.header['Content-Type']).to include 'application/json'
    end

    it 'returns an array of parsers' do
      get :datatable
      JSON.parse(response.body)['data'].each do |parser|
        expect(parser).to include(
          * %w[id name strategy updated_at last_editor data_type source partner can_update]
        )
        expect(parser['source']).to include(* %w[id name])
        expect(parser['partner']).to include(* %w[id name])
      end
    end
  end

  describe "GET 'show'" do
    it 'finds an existing parser' do
      expect(Parser).to receive(:find).with('1234') { parser }
      get :show, params: { id: '1234' }
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
      get :edit, params: { id: '1234' }
      expect(assigns(:parser)).to eq parser
    end

    it 'initializes a harvest_job' do
      expect(HarvestJob).to receive(:from_parser).with(parser, user) { job }
      get :edit, params: { id: '1234' }
      expect(assigns(:harvest_job)).to eq job
    end
  end

  describe "GET 'create'" do
    it 'initializes a new parser' do
      expect(Parser).to receive(:new).with('name' => 'Tepapa') { parser }
      post :create, params: { parser: { name: 'Tepapa' } }
    end

    it 'saves the parser' do
      expect { post :create, params: { parser: { name: 'Tepapa', source_id: source, strategy: 'json' } } }.to change(Parser, :count).by(1)
    end

    context 'valid parser' do
      it 'redirects to the edit page' do
        post :create, params: { parser: { name: 'Tepapa', source_id: source, strategy: 'json' } }
        expect(response.status).to eq 302
      end
    end

    context 'invalid parser' do
      before { allow(parser).to receive(:save) { false } }

      it 'renders the edit action' do
        post :create, params: { parser: { name: 'Tepapa' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET 'update'" do
    before do
      allow(Parser).to receive(:find) { parser }
      allow(parser).to receive(:update_attributes) { true }
    end

    it 'finds an existing parser ' do
      expect(Parser).to receive(:find).with('1234') { parser }
      put :update, params: { id: '1234', parser: { name: '' } }
      expect(assigns(:parser)).to eq parser
    end

    it 'updates the parser attributes' do
      put :update, params: { id: '1234', parser: { name: 'Tepapa' } }
      expect(parser.name).to eq 'Tepapa'
    end

    it 'saves the parser' do
      expect(parser).to receive(:save)
      put :update, params: { id: '1234', parser: { name: 'Tepapa' } }
    end

    context 'valid parser' do
      before { allow(parser).to receive(:save) { true } }

      it 'redirects to edit page' do
        put :update, params: { id: parser.id, parser: { name: '' } }
        expect(response).to redirect_to edit_parser_path(parser.id)
      end
    end

    context 'invalid parser' do
      before { allow(parser).to receive(:save) { false } }

      it 'renders the edit action' do
        put :update, params: { id: '1234', parser: { name: '' } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "GET 'destroy'" do
    before do
      allow(Parser).to receive(:find) { parser }
      allow(parser).to receive(:destroy) { true }
    end

    context 'job not running for parser' do
      before { allow(parser).to receive(:running_jobs?) { false } }

      it 'finds an existing parser ' do
        expect(Parser).to receive(:find).with('1234') { parser }
        delete :destroy, params: { id: '1234' }
        expect(assigns(:parser)).to eq parser
      end

      it 'destroys the parser config' do
        expect(parser).to receive(:destroy)
        delete :destroy, params: { id: '1234' }
      end
    end

    it 'does not destroy if there are currently running jobs' do
      allow(parser).to receive(:running_jobs?) { true }
      expect(parser).not_to receive(:destroy)
      delete :destroy, params: { id: '1234' }
    end
  end

  describe "GET 'allow_flush'" do
    before do
      allow(Parser).to receive(:find) { parser }
      allow(parser).to receive(:allow_full_and_flush) { true }
      allow(parser).to receive(:save) { true }
    end

    it 'sets the allow_full_and_flush to true' do
      get :allow_flush, params: { id: parser.id, allow: true }
      expect(assigns(:parser).allow_full_and_flush).to be true
    end
  end
end

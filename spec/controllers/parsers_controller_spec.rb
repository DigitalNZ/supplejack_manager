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

  before do
    sign_in user

    allow(parser).to receive(:find_version).and_return(version)
  end

  describe 'GET index' do
    it 'returns a 200 status code' do
      get :index

      expect(response).to be_successful
    end
  end

  describe 'GET datatable' do
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

      expect(response).to be_successful
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

  describe 'GET show' do
    it 'finds an existing parser' do
      get :show, params: { id: parser.id }

      expect(assigns(:parser)).to eq parser
    end
  end

  describe 'GET new' do
    it 'initializes a new parser' do
      get :new

      expect(assigns(:parser)).to be_a_new(Parser)
    end
  end

  describe 'GET edit' do
    let(:job) { build(:harvest_job) }

    it 'finds an existing parser' do
      get :edit, params: { id: parser.id }

      expect(assigns(:parser)).to eq parser
    end

    it 'initializes a harvest_job' do
      expect(HarvestJob).to receive(:from_parser).with(parser, user).and_return(job)

      get :edit, params: { id: parser.id }

      expect(assigns(:harvest_job)).to eq job
    end
  end

  describe 'GET versions' do
    before { get :versions, params: { id: parser.id } }

    it 'assigns parser' do
      expect(assigns(:parser)).to eq parser
    end

    it 'assigns versions' do
      expect(assigns(:versions)).to eq parser.versions.select(&:valid?)
    end

    it 'assigns parser to versionable' do
      expect(assigns(:versionable)).to eq parser
    end
  end

  describe 'GET create' do
    it 'initializes a new parser' do
      expect(Parser).to receive(:new).with('name' => 'Tepapa').and_return(parser)

      post :create, params: { parser: { name: 'Tepapa' } }
    end

    it 'saves the parser' do
      expect { post :create, params: { parser: { name: 'Tepapa', source_id: source, strategy: 'json' } } }.to change(Parser, :count).by(1)
    end

    context 'when parser is valid' do
      it 'redirects to the edit page' do
        post :create, params: { parser: { name: 'Tepapa', source_id: source, strategy: 'json' } }
        expect(response.status).to eq 302
      end
    end

    context 'when parser is invalid' do
      it 'renders the edit action' do
        post :create, params: { parser: { name: 'Tepapa' } }

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET update' do
    it 'finds an existing parser ' do
      put :update, params: { id: parser.id, parser: { name: '' } }

      expect(assigns(:parser)).to eq parser
    end

    it 'updates the parser attributes' do
      put :update, params: { id: parser.id, parser: { name: 'Tepapa' } }

      parser.reload

      expect(parser.name).to eq 'Tepapa'
    end

    context 'when parser is valid' do
      it 'redirects to edit page' do
        put :update, params: { id: parser.id, parser: { name: 'Tepapa' } }

        expect(response).to redirect_to edit_parser_path(parser.id)
      end
    end

    context 'when parser is invalid' do
      it 'renders the edit action' do
        put :update, params: { id: parser.id, parser: { name: '' } }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET destroy' do
    before { allow(Parser).to receive(:find) { parser } }

    context 'when job not running for parser' do
      before { allow(parser).to receive(:running_jobs?).and_return(false) }

      it 'destroys the parser' do
        expect(parser).to receive(:destroy)

        delete :destroy, params: { id: parser.id }
      end
    end

    context 'when job not running for parser' do
      before { allow(parser).to receive(:running_jobs?).and_return(true) }

      it 'does not destroy if there are currently running jobs' do
        expect(parser).not_to receive(:destroy)

        delete :destroy, params: { id: parser.id }
      end
    end
  end

  describe 'GET allow_flush' do
    before { allow(parser).to receive(:allow_full_and_flush) { true } }

    it 'sets the allow_full_and_flush to true' do
      get :allow_flush, params: { id: parser.id, allow: true }

      expect(assigns(:parser).allow_full_and_flush).to be true
    end
  end

  describe 'GET edit_meta' do
    before { get :edit_meta, params: { id: parser.id } }

    it 'returns a 200 status code' do
      expect(response).to be_successful
    end

    it 'returns assigns parser' do
      expect(assigns(:parser)).to eq parser
    end

    it 'returns assigns partners' do
      expect(assigns(:partners)).to eq Partner.all
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SourcesController do
  let(:partner) { create(:partner) }
  let(:source)  { create(:source) }
  let(:admin)    { create(:user, :admin) }

  before do
    sign_in admin

    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  def valid_attributes
    attributes_for(:source, partner_id: partner.id)
  end

  describe 'GET index' do
    it 'assigns all sources as @sources' do
      get :index

      expect(assigns(:sources)).to eq([source])
    end
  end

  describe 'GET show' do
    it 'assigns all sources as @sources' do
      get :show, params: { id: source.id, format: :json }

      expect(assigns(:source)).to eq(source)
    end
  end

  describe 'GET new' do
    it 'assigns a new source as @source' do
      get :new

      expect(assigns(:source)).to be_a_new(Source)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested source as @source' do
      get :edit, params: { id: source.to_param }

      expect(assigns(:source)).to eq(source)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Source' do
        expect do
          post :create, params: { source: valid_attributes }
        end.to change(Source, :count).by(1)
      end

      it 'assigns a newly created source as @source' do
        post :create, params: { source: valid_attributes }

        expect(assigns(:source)).to be_a(Source)
        expect(assigns(:source)).to be_persisted
      end

      it 'redirects to the sources page' do
        post :create, params: { source: valid_attributes }
        expect(response).to redirect_to sources_path
      end

      it 'creates a source with a nested contributor' do
        expect do
          post :create, params: { source: { source_id: 'Data Source', partner_id: partner.id, partner_attributes: { name: 'Contributor' } } }
        end.to change(Partner, :count).by(1)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved source as @source' do
        post :create, params: { source: { source_id: '' } }
        expect(assigns(:source)).to be_a_new(Source)
      end

      it "re-renders the 'new' template" do
        post :create, params: { source: { source_id: '' } }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested source' do
        put :update, params: { id: source.to_param, source: { source_id: 'updated' } }

        expect(source.reload.source_id).to eq 'updated'
      end

      it 'assigns the requested source as @source' do
        put :update, params: { id: source.to_param, source: valid_attributes }

        expect(assigns(:source)).to eq(source)
      end

      it 'redirects to the sources index' do
        put :update, params: { id: source.to_param, source: valid_attributes }

        expect(response).to redirect_to sources_path
      end
    end

    describe 'with invalid params' do
      it 'assigns the source as @source' do
        put :update, params: { id: source.to_param, source: { source_id: '' } }

        expect(assigns(:source)).to eq(source)
      end

      it "re-renders the 'edit' template" do
        put :update, params: { id: source.to_param, source: { source_id: '' } }

        expect(response).to render_template('edit')
      end
    end

    describe 'GET reindex' do
      it 'calls reindex on api' do
        source = Source.create! valid_attributes
        expect(Api::Source).to receive(:reindex).with('test', source.id, { date: '2013-09-12T01:49:51.067Z' })
        get :reindex, params: { id: source.to_param, environment: 'test', date: '2013-09-12T01:49:51.067Z', format: :js }
      end
    end
  end
end

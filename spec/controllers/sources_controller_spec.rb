# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'rails_helper'

describe SourcesController do
  let(:partner) { create(:partner) }
  let(:user)    { create(:user, :admin) }

  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  def valid_attributes
    attributes_for(:source, partner_id: partner.id)
  end

  before(:each) do
    sign_in user
  end

  describe 'GET index' do
    it 'assigns all sources as @sources' do
      source = Source.create! valid_attributes
      get :index, {}
      expect(assigns(:sources)).to eq([source])
    end
  end

  describe "GET new" do
    it "assigns a new source as @source" do
      get :new, {}
      expect(assigns(:source)).to be_a_new(Source)
    end
  end

  describe "GET edit" do
    it "assigns the requested source as @source" do
      source = Source.create! valid_attributes
      get :edit, params: { id:  source.to_param }
      expect(assigns(:source)).to eq(source)
    end
  end

  describe "POST create" do
    before(:each) {
      allow(controller).to receive(:current_user) { build(:user, role: 'admin') }
    }

    describe 'with valid params' do
      it 'creates a new Source' do
        expect {
          post :create, params: { source: valid_attributes }
        }.to change(Source, :count).by(1)
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
        expect {
          post :create, params: { source: { name: 'Data Source', partner_id: partner.id, partner_attributes: { name: 'Contributor' }} }
        }.to change(Partner, :count).by(1)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved source as @source" do
        post :create, params: { source: { name: '' }}
        expect(assigns(:source)).to be_a_new(Source)
      end

      it "re-renders the 'new' template" do
        post :create, params: { source: { name: '' } }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    before(:each) {
      allow(controller).to receive(:current_user) { build(:user, role: 'admin') }
    }

    describe 'with valid params' do
      it 'updates the requested source' do
        source = Source.create! valid_attributes
        put :update, params: { id: source.to_param, source: { name: 'updated' }}
      end

      it "assigns the requested source as @source" do
        source = Source.create! valid_attributes
        put :update, params: { id: source.to_param, source: valid_attributes }
        expect(assigns(:source)).to eq(source)
      end

      it "redirects to the sources index" do
        source = Source.create! valid_attributes
        put :update, params: { id: source.to_param, source: valid_attributes }
        expect(response).to redirect_to sources_path
      end
    end

    describe "with invalid params" do
      it "assigns the source as @source" do
        source = Source.create! valid_attributes
        put :update, params: { id: source.to_param, source: { name: '' } }
        expect(assigns(:source)).to eq(source)
      end

      it "re-renders the 'edit' template" do
        source = Source.create! valid_attributes
        put :update, params: { id: source.to_param, source: { name: '' }}
        expect(response).to render_template('edit')
      end
    end

    describe "GET reindex" do
      before(:each) {
        allow(controller).to receive(:current_user) { build(:user, role: 'admin') }
      }

      it "calls reindex on api" do
        source = Source.create! valid_attributes
        expect(RestClient).to receive(:get).with("#{ENV['API_HOST']}/harvester/sources/#{source.id}/reindex", params: { date: '2013-09-12T01:49:51.067Z', api_key: ENV['HARVESTER_API_KEY'] })
        get :reindex,  params: { id: source.to_param, env: 'test', date: "2013-09-12T01:49:51.067Z", format: :js }
      end
    end
  end
end


require 'rails_helper'

RSpec.describe SnippetsController do
  let(:snippet) { create(:snippet) }
  let(:user)    { create(:user, :admin) }
  let(:version) { create(:version, versionable: snippet) }

  before(:each) do
    sign_in user
    allow(Snippet).to receive(:find).with(anything) { snippet }
    allow(snippet).to receive(:find_version) { version }
  end

  describe 'GET index' do
    it 'should assign all @snippets' do
      expect(Snippet).to receive(:all) { [snippet] }
      get :index
      expect(assigns(:snippets)).to eq [snippet]
    end
  end

  describe 'GET new' do
    it 'initializes a new snippet' do
      expect(Snippet).to receive(:new) { snippet }
      get :new
      expect(assigns(:snippet)).to eq snippet
    end
  end

  describe 'GET edit' do
    it 'finds an existing snippet' do
      expect(Snippet).to receive(:find).with('1234') { snippet }
      get :edit, params: { id: '1234' }
      expect(assigns(:snippet)).to eq snippet
    end
  end

  describe 'GET create' do
    before do
      allow(Snippet).to receive(:new) { snippet }
      allow(snippet).to receive(:save) { true }
    end

    it 'initializes a new snippet' do
      expect(Snippet).to receive(:new).with({'name' => 'Copyright'}) { snippet }
      post :create, params: { snippet: { name: 'Copyright' } }
    end

    it 'saves the snippet' do
      expect(snippet).to receive(:save)
      post :create, params: { snippet: {name: 'Copyright'} }
    end

    context 'valid snippet' do
      it 'redirects to edit page' do
        post :create, params: { snippet: { name: 'Copyright' } }
        expect(response.status).to eq 302
      end
    end

    context 'invalid snippet' do
      before { allow(snippet).to receive(:save) { false }}

      it 'renders the edit action' do
        post :create, params: { snippet: { name: 'Copyright' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET update' do
    before do
      allow(Snippet).to receive(:find) { snippet }
      allow(snippet).to receive(:update_attributes) { true }
    end

    it 'updates the snippet attributes' do
      expect(snippet).to receive(:update_attributes).with({ 'name' => 'Copyright',
                                                            'message' => 'update cho self',
                                                            'content': 'I am a snippet',
                                                            'environment': 'test'})
      put :update, params: { id: '1234', snippet: { name: 'Copyright',
                                                    message: 'update cho self',
                                                    content: 'I am a snippet',
                                                    environment: 'test' }}
    end

    context 'valid snippet' do
      it 'redirects to edit page' do
        put :update, params: { id: '1234', snippet: { name: '' } }
        expect(response.status).to eq 302
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the snippet' do
      expect(Snippet).to receive(:find).with(snippet.id) { snippet }
      expect(snippet).to receive(:destroy)
      delete :destroy, params: { id: snippet.id }
      expect(response).to redirect_to snippets_path
    end
  end

  describe 'GET current_version' do
    before do
      allow(Snippet).to receive(:find_by_name) { snippet }
    end

    it 'should find the current version of the snippet' do
      expect(Snippet).to receive(:find_by_name).with('Copyright', 'staging') { snippet }
      get :current_version, params: { name: 'Copyright', environment: :staging, format: :json }
      expect(assigns(:snippet)).to eq snippet
    end
  end
end

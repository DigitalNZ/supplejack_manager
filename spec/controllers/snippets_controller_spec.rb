# frozen_string_literal: true

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
      get :index

      expect(assigns(:snippets)).to eq [snippet]
    end
  end

  describe 'GET new' do
    it 'initializes a new snippet' do
      get :new

      expect(assigns(:snippet)).to be_a_new Snippet
    end
  end

  describe 'GET edit' do
    it 'finds an existing snippet' do
      get :edit, params: { id: snippet.id }

      expect(assigns(:snippet)).to eq snippet
    end
  end

  describe 'GET versions' do
    before { get :versions, params: { id: snippet.id } }

    it 'assigns snippet' do
      expect(assigns(:snippet)).to eq snippet
    end

    it 'assigns versions' do
      expect(assigns(:versions)).to eq snippet.versions
    end

    it 'assigns snippet to versionable' do
      expect(assigns(:versionable)).to eq snippet
    end
  end

  describe 'POST create' do
    it 'redirects to edit page' do
      post :create, params: { snippet: { name: 'Copyright' } }

      expect(response).to be_a_redirect
    end
  end

  describe 'PATCH update' do
    before do
      allow(Snippet).to receive(:find) { snippet }
      allow(snippet).to receive(:update_attributes) { true }
    end

    it 'updates the snippet attributes' do
      expect(snippet).to receive(:update_attributes).with({ 'name' => 'Copyright',
                                                            'message' => 'update cho self',
                                                            'content': 'I am a snippet',
                                                            'environment': 'test' })

      patch :update, params: { id: '1234', snippet: { name: 'Copyright',
                                                      message: 'update cho self',
                                                      content: 'I am a snippet',
                                                      environment: 'test' } }
    end

    context 'valid snippet' do
      it 'redirects to edit page' do
        patch :update, params: { id: snippet.id, snippet: { name: '' } }

        expect(response).to be_a_redirect
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the snippet' do
      allow(Snippet).to receive(:find).with(snippet.id).and_return(snippet)
      expect(snippet).to receive(:destroy)

      delete :destroy, params: { id: snippet.id }

      expect(response).to redirect_to snippets_path
    end
  end

  describe 'GET current_version' do
    it 'should find the current version of the snippet' do
      expect(Snippet).to receive(:find_by_name).with('Copyright', 'staging') { snippet }

      get :current_version, params: { name: 'Copyright', environment: :staging, format: :json }

      expect(assigns(:snippet)).to eq snippet
    end
  end
end

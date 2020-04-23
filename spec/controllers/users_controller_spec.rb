# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController do
  let(:user)       { create(:user, :admin, email: 'email@example.com') }
  let(:other_user) { create(:user, :admin, email: 'other@example.com') }

  before(:each) do
    sign_in user
  end

  describe 'GET #index' do
    it 'should render the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'should find all active users' do
      expect(User).to receive(:active) { [user] }
      get :index
      expect(assigns(:users)).to eq [user]
    end

    context 'active=false' do
      it 'should find all deactivated users' do
        expect(User).to receive(:deactivated) { [user] }
        get :index, params: { active: 'false' }
        expect(assigns(:users)).to eq [user]
      end
    end
  end

  describe 'GET #new' do
    it 'it should render the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'should should assign new user to @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    context 'valid input' do
      before(:each) do
        @valid_user = { name: 'Sample User', email: 'sample@sample.com', password: '123456', password_confirmation: '123456', role: 'user' }
      end

      it 'redirects to index template' do
        post :create, params: { user: @valid_user }
        expect(response).to redirect_to(users_path)
      end

      it 'should save the user' do
        expect {
          post :create, params: { user: @valid_user }
        }.to change(User, :count).by(1)
      end
    end

    context 'invalid input' do
      it 'renders new template' do
        post :create, params: { user: { name: 'Invalid user' } }
        expect(response).to render_template(:new)
      end

      it 'should not save the user' do
        expect {
          post :create, params: { user: { name: 'Invalid user' } }
        }.to change(User, :count).by(0)
      end
    end
  end

  describe 'GET #edit' do
    it 'renders edit template' do
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end

    it 'should assign the current_user to @user' do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq user
    end
  end

  describe 'PUT #update' do
    it 'should find the user' do
      expect(User).to receive(:find) { user }
      put :update, params: { id: other_user.id, user: { name: 'User' } }
    end

    it 'redirects to index template' do
      put :update, params: { id: other_user.id, user: { name: 'User' } }
      expect(response).to redirect_to(users_path)
    end

    it 'assigns user to instance variable' do
      put :update, params: { id: other_user.id, user: { name: 'User' } }
      expect(assigns(:user)).to eq other_user
    end

    context 'valid input' do
      it 'should update the user' do
        put :update, params: { id: other_user.id, user: { name: 'User' } }
        other_user.reload
        expect(other_user.email).to eq 'other@example.com'
      end

      it 'renders users path' do
        put :update, params: { id: other_user.id, user: { email: 'other@example.com' } }
        other_user.reload
        expect(response).to redirect_to(users_path)
      end

      it 'should sign in if the user is the current user' do
        expect(controller).to receive(:bypass_sign_in)
        put :update, params: { id: user.id, user: { name: 'User' } }
      end

      it 'should not sign in the user if not the current user' do
        expect(controller).not_to receive(:sign_in)
        put :update, params: { id: other_user.id, user: { name: 'User' } }
      end
    end

    context 'invalid input' do
      it 'should not update the user' do
        put :update, params: { id: other_user.id, user: { email: 'invalid_email' } }
        other_user.reload
        expect(other_user.email).to eq 'other@example.com'
      end
    end
  end
end

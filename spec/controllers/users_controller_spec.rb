# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe UsersController do
  let(:user)       { instance_double(User, id: '1234', email: 'email@example.com').as_null_object }
  let(:other_user) { instance_double(User, id: '4321', email: 'other@example.com').as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
  end

  describe 'GET #index' do
    it 'should render the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'should find all active users' do
      User.should_receive(:active) { [user] }
      get :index
      expect(assigns(:users)).to eq [user]
    end

    context 'active=false' do
      it 'should find all deactivated users' do
        User.should_receive(:deactivated) { [user] }
        get :index, active: 'false'
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
        @valid_user = { name: 'Sample User', email: 'sample@sample.com', password: '123456', password_confirmation: '123456' }
      end

      it 'redirects to index template' do
        post :create, user: @valid_user
        expect(response).to redirect_to(users_path)
      end

      it 'should save the user' do
        expect {
          post :create, user: @valid_user
        }.to change(User, :count).by(1)
      end
    end

    context 'invalid input' do
      it 'renders new template' do
        post :create, user: { name: 'Invalid user' }
        expect(response).to render_template(:new)
      end

      it 'should not save the user' do
        expect {
          post :create, user: { name: 'Invalid user' }
        }.to change(User, :count).by(0)
      end
    end
  end

  describe 'GET #edit' do
    before(:each) do
      User.stub(:find) { user }
    end

    it 'renders edit template' do
      get :edit, id: user.id
      expect(response).to render_template(:edit)
    end

    it 'should assign the current_user to @user' do
      get :edit, id: user.id
      expect(assigns(:user)).to eq user
    end
  end

  describe 'PUT #update' do
    before(:each) do
      User.stub(:find) { other_user }
    end

    it 'should find the user' do
      User.should_receive(:find)
      put :update, id: other_user.id
    end

    it 'redirects to index template' do
      put :update, id: other_user.id
      expect(response).to redirect_to(users_path)
    end

    it 'assigns user to instance variable' do
      put :update, id: other_user.id
      expect(assigns(:user)).to eq other_user
    end

    context 'valid input' do
      it 'should update the user' do
        put :update, id: other_user.id, user: { name: 'User' }
        other_user.reload
        expect(other_user.email).to eq 'other@example.com'
      end

      it 'renders users path' do
        put :update, id: other_user.id, user: { email: 'other@example.com' }
        other_user.reload
        expect(response).to redirect_to(users_path)
      end

      it 'should sign in if the user is the current user' do
        User.stub(:find) { user }
        controller.should_receive(:sign_in)
        put :update, id: user.id, user: { name: 'User' }
      end

      it 'should not sign in the user if not the current user' do
        User.stub(:find) { other_user }
        controller.should_not_receive(:sign_in)
        put :update, id: other_user.id, user: { name: 'User' }
      end
    end

    context 'invalid input' do
      it 'should not update the user' do
        put :update, id: other_user.id, user: { email: 'invalid_email' }
        other_user.reload
        expect(other_user.email).to eq 'other@example.com'
      end
    end
  end
end

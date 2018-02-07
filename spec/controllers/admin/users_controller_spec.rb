# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { create(:user, email: 'info@boost.co.nz') }

  before do
    sign_in(user)
  end

  describe '#index' do
    before do
      allow_any_instance_of(Admin::User).to receive(:all) { true }
      allow_any_instance_of(Admin::User).to receive(:total) { 1 }
    end

    context 'html' do
      before do
        get :index, params: { environment: 'development' }
      end

      it 'renders with a succesful status code' do
        expect(response.status).to eq 200
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end
    end

    context 'csv' do
      before do
        get :index, format: :csv, params: { environment: 'development' }
      end

      it 'renders a status 200 for CSV' do
        expect(response.status).to eq 200
      end

      it 'renders the CSV file' do
        expect(response.header['Content-Type']).to include 'text/csv'
      end
    end
  end

  describe '#edit' do
    before do
      allow_any_instance_of(Admin::User).to receive(:find) { true }
      get :edit, params: { id: 1, environment: 'development' }
    end

    it 'renders a successful status code' do
      expect(response.status).to eq 200
    end

    it 'renders the :edit template' do
      expect(response).to render_template :edit
    end
  end

  describe '#update' do
    before do
      allow_any_instance_of(Admin::User).to receive(:update) { true }
      allow_any_instance_of(Admin::User).to receive(:find) { true }
    end

    it 'updates the admin_user' do
      patch :update, params: { id: 1, user: { max_requests: 1 }, environment: 'development' }
      expect(response).to redirect_to environment_admin_users_path
    end
  end
end

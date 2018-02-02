# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { create(:user, email: 'info@boost.co.nz') }
  let(:admin_users) { build_list(:admin_user, 5) }

  before do
    sign_in(user)
  end

  describe '#index' do
    before do
      allow(Admin::User).to receive(:all) { admin_users }
    end

    context 'html' do
      before do
        get :index
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
        get :index, format: :csv
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
      allow(Admin::User).to receive(:find) { admin_users.first }
      get :edit, params: { id: 1 }
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
      allow_any_instance_of(Admin::User).to receive(:update_attributes) { true }
      allow(Admin::User).to receive(:find) { admin_users.first }
    end

    it 'updates the admin_user' do
      patch :update, params: { id: 1, admin_user: attributes_for(:admin_user) }
      expect(response).to redirect_to admin_users_path
    end
  end
end

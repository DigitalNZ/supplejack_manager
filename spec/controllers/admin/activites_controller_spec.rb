# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ActivitiesController do
  let(:user) { create(:user, :admin, email: 'info@boost.co.nz') }

  before do
    sign_in(user)
  end

  describe '#index' do
    context 'html' do
      before do
        get :index, params: { environment: 'development' }
      end

      it 'returns a succesfull status code' do
        expect(response).to have_http_status(200)
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end
    end

    context 'csv' do
      before do
        get :index, params: { environment: 'development' }, format: :csv
      end

      it 'renders a succesful status code' do
        expect(response.status).to eq 200
      end

      it 'renders the CSV file' do
        expect(response.header['Content-Type']).to include 'text/csv'
      end
    end
  end
end

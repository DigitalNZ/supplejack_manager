# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ApplicationController do
  controller do
    def index
      render body: 'success'
    end
  end

  describe '#authenticate_user!' do
    context 'with an authorization token' do
      it 'returns a status 200 with a valid token' do
        request.headers['Authorization'] = "Token token=#{ENV['WORKER_KEY']}"
        get :index
        expect(response.status).to eq 200
        expect(response.body).to eq 'success'
      end

      it 'returns a 401' do
        request.headers['Authorization'] = 'Token token=somerandomkey'
        get :index
        expect(response.status).to eq 401
        expect(response.body).to eq "HTTP Token: Access denied.\n"
      end
    end

    context 'without an authorization token, it falls back to devise' do
      it 'renders a status 200' do
        sign_in FactoryBot.create(:user)
        get :index
        expect(response.status).to eq 200
        expect(response.body).to eq 'success'
      end

      it 'returns a status 302' do
        get :index
        expect(response.status).to eq 302
        expect(response).to redirect_to('/users/sign_in')
      end
    end
  end
end

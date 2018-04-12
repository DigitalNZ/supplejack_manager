# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ActivitesController do
  describe '#index' do
    it 'returns a succesfull status code' do
      get :index
      expect(response).to have_http_status(200)
    end
  end
end

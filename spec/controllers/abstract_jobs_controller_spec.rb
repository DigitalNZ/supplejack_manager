# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AbstractJobsController do
  before(:each) do
    sign_in create(:user)
  end

  describe 'GET index' do
    it 'returns active abstract jobs' do
      expect(AbstractJob).to receive(:search).with({ 'status' => 'active', 'environment' => 'staging' })
      get :index, params: { status: 'active', environment: 'staging' }
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HarvestJobsController do
  let(:job) { build(:harvest_job) }

  before(:each) do
    sign_in create(:user)
  end

  describe '#GET show' do
    it 'finds the harvest job' do
      expect(HarvestJob).to receive(:find) { job }
      get :show, params: { id: 1, environment: 'staging' }
      expect(assigns(:harvest_job)).to eq job
    end
  end

  describe 'PUT Update' do
    before(:each) do
      allow(HarvestJob).to receive(:find).with('1') { job }
    end

    it 'should update the attributes' do
      expect(job).to receive(:update_attributes)
      expect(job).to receive(:id) { 'myid' }
      put :update, params: { id: 1, harvest_job: { status: 'finished' }, environment: 'staging' }
    end
  end
end

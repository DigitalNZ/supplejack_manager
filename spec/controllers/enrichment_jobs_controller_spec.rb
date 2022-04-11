# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnrichmentJobsController do
  let(:enrichment_job) { build(:enrichment_job) }
  let(:user)           { create(:user, :admin) }

  before do
    sign_in user
  end

  describe '#show' do
    before do
      allow(EnrichmentJob).to receive(:find) { enrichment_job }
    end

    it 'assigns the correct @enrichment_job' do
      get :show, params: { id: 1, environment: 'staging' }
      expect(assigns(:enrichment_job)).to eq enrichment_job
    end
  end

  describe 'PUT #update' do
    it 'checks whether the \'stopped\' parameter is passed to the Enrichment Job' do
      allow(EnrichmentJob).to receive(:find).and_return(enrichment_job)
      allow_any_instance_of(EnrichmentJob).to receive(:update_attributes)

      put :update, params: { id: 1, environment: 'staging', enrichment_job: attributes_for(:enrichment_job, :stopped) }

      expect(controller.send(:enrichment_job_params)[:status]).to eql 'stopped'
    end
  end
end

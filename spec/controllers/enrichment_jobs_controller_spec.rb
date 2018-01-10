# frozen_string_literal: true

require 'spec_helper'

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
      get :show, id: 1, environment: 'staging'
      expect(assigns(:enrichment_job)).to eq enrichment_job
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EnrichmentJobsController do
  let(:enrichment_job) { build(:enrichment_job) }

  before do
  end

  describe '#show' do
    it 'assigns the correct @enrichment_job' do
      expect(EnrichmentJob).to receive(:find) { enrichment_job }
      get :show, id: enrichment_job
      expect(assigns(:enrichment_job)).to eq enrichment_job
    end
  end
end

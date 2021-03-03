# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Enrichment Jobs Spec', js: true do
  context 'signed out user' do
    scenario 'is redirected to user sign in page' do
      visit environment_enrichment_job_path(environment: 'staging', id: 1)
      expect(page.current_path).to eq new_user_session_path
    end
  end

  context 'showing a harvest job details' do
    before do
      sign_in create(:user)
    end

    scenario 'of active job' do
      job = build(:enrichment_job)
      expect(EnrichmentJob).to receive(:find) { job }

      visit environment_enrichment_job_path(job.environment, id: job.id)
      expect(page).to have_link('Stop Enrichment')
      expect(page).to_not have_button('Resume Enrichment')
    end

    scenario 'of finished job' do
      job = build(:enrichment_job, :finished)
      expect(EnrichmentJob).to receive(:find) { job }

      visit environment_enrichment_job_path(job.environment, id: job.id)
      expect(page).to_not have_button('Resume Enrichment')
    end

    scenario 'of a failed job' do
      job = build(:enrichment_job, :failed)
      expect(EnrichmentJob).to receive(:find) { job }

      visit environment_enrichment_job_path(job.environment, id: job.id)
      expect(page).to have_button('Resume Enrichment')
    end

    scenario 'of a stopped job' do
      job = build(:enrichment_job, :stopped)
      expect(EnrichmentJob).to receive(:find) { job }

      visit environment_enrichment_job_path(job.environment, id: job.id)
      expect(page).to have_button('Resume Enrichment')
    end
  end
end

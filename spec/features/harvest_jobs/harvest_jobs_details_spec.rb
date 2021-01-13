# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Harvest Jobs Spec', js: true do
  context 'showing a harvest job details' do
    before do
      sign_in create(:user, :admin)
    end

    scenario 'of active job' do
      job = build(:harvest_job, :active)
      expect(HarvestJob).to receive(:find) { job }

      visit environment_harvest_job_path(job.environment, id: job.id)
      expect(page).to have_link('Stop Harvest')
      expect(page).to_not have_button('Resume Harvest')
    end

    scenario 'of finished job' do
      job = build(:harvest_job, :finished)
      expect(HarvestJob).to receive(:find) { job }

      visit environment_harvest_job_path(job.environment, id: job.id)
      expect(page).to_not have_link('Stop Harvest')
      expect(page).to_not have_button('Resume Harvest')
    end

    def resumable_jobs_spec(job)
      allow(HarvestJob).to receive(:find).and_return(job, job)

      visit environment_harvest_job_path(job.environment, id: job.id)
      expect(page).to_not have_link('Stop Harvest')
      click_button 'Resume Harvest'

      click_button 'No'
      click_button 'Resume Harvest'
      click_button 'Yes'
    end

    scenario 'of a failed job' do
      parser = create(:parser)
      job = build(:harvest_job, :failed, parser_id: parser.id)
      resumable_jobs_spec(job)
    end

    scenario 'of a stopped job' do
      parser = create(:parser)
      job = build(:harvest_job, :stopped, parser_id: parser.id)
      resumable_jobs_spec(job)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Abscrtract Job Dashboard', type: :feature do
  let(:user) { create(:user, :admin) }

  context 'a user that is logged out' do
    scenario 'gets redirected to the sign in page' do
      visit environment_abstract_jobs_path(environment: 'staging')
      expect(page.current_path).to eq new_user_session_path
    end
  end

  context 'Active jobs', js: true do
    before do
      allow_any_instance_of(Partner).to receive(:update_apis)
      allow_any_instance_of(Source).to receive(:update_apis)
      allow(LinkCheckRule).to receive(:create)
      visit new_user_session_path
      within(:css, 'form.user-signin-form') do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
      end

      click_button 'Sign in'

      allow(AbstractJob).to receive(:search).and_return Kaminari::PaginatableArray.new([abstract_job], {limit: 50, offset: 0, total_count: 1})
    end

    let(:source) { create(:source) }
    let(:parser) { create(:parser, source: source) }
    let(:abstract_job) do
      build(:abstract_job, status: 'active',
                           mode: 'Normal',
                           user_id: user.id,
                           parser_id: parser.id,
                           start_time: Time.zone.now - 1.hour,
                           _type: 'HarvestJob',
                           version_id: '999')
    end

    before :each do
      visit environment_abstract_jobs_path(status: 'active', environment: 'staging')
    end

    scenario 'displays job details' do
      expect(page.has_content?(abstract_job.parser.name))
      expect(page.has_content?(abstract_job.mode))
      expect(page.has_content?(abstract_job.user.name))
      expect(page.has_content?(I18n.l(abstract_job.start_time, format: :long)))
      expect(page.has_content?(abstract_job.records_count))
    end

    scenario 'has links to the parser and the harvest job details' do
      expect(page.has_link?(abstract_job.parser.name, parser_parser_version_path(parser_id: parser.id, id: abstract_job.version_id))).to be true
      expect(page.has_link?('View details', environment_harvest_job_path('staging', id: abstract_job.id))).to be true
    end
  end
end

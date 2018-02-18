# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Job Schedules', type: :feature do
  let(:user) { create(:user, :admin) }

  context 'a user that is logged out' do
    scenario 'gets redirected to the sign in page' do
      visit environment_harvest_schedules_path(environment: 'staging')
      expect(page.current_path).to eq new_user_session_path
    end
  end

  context 'One off schedules' do
    before do
      allow_any_instance_of(Partner).to receive(:update_apis)
      allow_any_instance_of(Source).to receive(:update_apis)
      allow(LinkCheckRule).to receive(:create)
      allow(HarvestSchedule).to receive(:all).and_return([one_off_schedule])

      visit new_user_session_path
      within(:css, 'form.user-signin-form') do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
      end

      click_button 'Sign in'
    end

    let(:source) { create(:source) }
    let(:parser) { create(:parser, source: source) }
    let(:one_off_schedule) { build(:harvest_schedule, recurrent: false, parser_id: parser.id) }

    before :each do
      one_off_schedule.id = 1
      visit environment_harvest_schedules_path(environment: 'staging')
    end

    scenario 'displays one off schedule details' do
      expect(page.has_content?(one_off_schedule.parser.name)).to be true
      expect(page.has_content?(I18n.l(one_off_schedule.start_time, format: :long))).to be true
      expect(page.has_content?(one_off_schedule.environment)).to be true
      expect(page.has_content?(one_off_schedule.mode)).to be true
    end

    scenario 'can click Edit link to go to update page', js: true do
      expect(HarvestSchedule).to receive(:find).and_return(one_off_schedule)
      click_link('Edit')

      expect(page.current_path).to eq edit_environment_harvest_schedule_path(environment: 'staging', id: 1)
    end

    scenario 'can click Delete link to delete job', js: true do
      expect(HarvestSchedule).to receive(:find).and_return(one_off_schedule)
      expect(one_off_schedule).to receive(:destroy)

      click_link('Delete')
    end

    scenario 'can click Resume link to pause job', js: true do
      expect(HarvestSchedule).to receive(:find).and_return(one_off_schedule)
      expect(one_off_schedule).to receive(:update_attributes).with('status'=>'active')

      find('input[value="Resume"]').click
    end

    scenario 'can click Pause link to pause job', js: true do
      one_off_schedule.status = 'active'
      visit environment_harvest_schedules_path(environment: 'staging')

      expect(HarvestSchedule).to receive(:find).and_return(one_off_schedule)
      expect(one_off_schedule).to receive(:update_attributes).with('status'=>'paused')

      find('input[value="Pause"]').click
    end
  end
end

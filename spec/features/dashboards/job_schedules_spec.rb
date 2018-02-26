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

    scenario 'clicking new schedule directs user to new schedule page' do
      click_link('New Schedule')
      expect(page.current_path).to eq new_environment_harvest_schedule_path(environment: 'staging')
    end
  end

  context 'Recurrent schedules' do
    before do
      allow_any_instance_of(Partner).to receive(:update_apis)
      allow_any_instance_of(Source).to receive(:update_apis)
      allow(LinkCheckRule).to receive(:create)
      allow(HarvestSchedule).to receive(:all).and_return([schedule1])

      visit new_user_session_path
      within(:css, 'form.user-signin-form') do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
      end

      click_button 'Sign in'
    end

    let(:source) { create(:source) }
    let(:parser) { create(:parser, source: source) }
    let(:schedule1) do
      build(:harvest_schedule, { recurrent: true,
                                 parser_id: parser.id,
                                 last_run_at: Time.zone.now - 1.hour,
                                 next_run_at: Time.zone.now + 1.hour,
                                 frequency: 'daily',
                                 at_minutes: '09',
                                 at_hours: '17',
                                 cron: '09 17 * * *' })
    end

    before :each do
      schedule1.id = 1
      visit environment_harvest_schedules_path(environment: 'staging')
    end

    scenario 'displays schedule details for schedules' do
      expect(page.has_content?(schedule1.parser.name)).to be true
      expect(page.has_content?(I18n.l(schedule1.start_time, format: :first_run_at))).to be true
      expect(page.has_content?(schedule1.environment)).to be true
      expect(page.has_content?(schedule1.mode)).to be true
      expect(page.has_content?(I18n.l(schedule1.start_time, format: :first_run_at))).to be true
      expect(page.has_content?(I18n.l(schedule1.next_run_at, format: :short))).to be true
    end

    scenario 'displays schedule frequency' do
      expect(page.has_content?('daily at 17:09'))
      expect(page.has_content?('09 17 * * *'))
    end

    scenario 'can click Edit link to go to update page', js: true do
      expect(HarvestSchedule).to receive(:find).and_return(schedule1)
      click_link('Edit')

      expect(page.current_path).to eq edit_environment_harvest_schedule_path(environment: 'staging', id: 1)
    end

    scenario 'can click Delete link to delete job', js: true do
      expect(HarvestSchedule).to receive(:find).and_return(schedule1)
      expect(schedule1).to receive(:destroy)

      click_link('Delete')
    end

    scenario 'can click Resume link to pause job', js: true do
      expect(HarvestSchedule).to receive(:find).and_return(schedule1)
      expect(schedule1).to receive(:update_attributes).with('status'=>'active')

      find('input[value="Resume"]').click
    end

    scenario 'can click Pause link to pause job', js: true do
      schedule1.status = 'active'
      visit environment_harvest_schedules_path(environment: 'staging')

      expect(HarvestSchedule).to receive(:find).and_return(schedule1)
      expect(schedule1).to receive(:update_attributes).with('status'=>'paused')

      find('input[value="Pause"]').click
    end
  end

  context 'With Many schedules' do
    before do
      allow_any_instance_of(Partner).to receive(:update_apis)
      allow_any_instance_of(Source).to receive(:update_apis)
      allow(LinkCheckRule).to receive(:create)
      allow(HarvestSchedule).to receive(:all).and_return(schedules)

      visit new_user_session_path
      within(:css, 'form.user-signin-form') do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
      end

      click_button 'Sign in'
    end

    let(:source) { create(:source) }
    let(:parser1) { create(:parser, source: source) }
    let(:parser2) { create(:parser, name: 'A 2nd name', source: source) }
    let(:attributes) do
      { recurrent: true,
        status: 'active',
        parser_id: parser1.id,
        last_run_at: Time.zone.now - 1.hour,
        next_run_at: Time.zone.now + 1.hour,
        frequency: 'daily',
        at_minutes: '09',
        at_hours: '17',
        cron: '09 17 * * *' }
    end

    let(:schedules) { build_list(:harvest_schedule, 2, attributes) }

    before :each do
      schedules.first.id = 1
      schedules.last.id = 2
      schedules.last.parser_id = parser2.id
      visit environment_harvest_schedules_path(environment: 'staging')
    end

    scenario 'clicking on Pause All' do
      schedules.each do |schedule|
        expect(schedule).to receive(:update_attributes).with('status'=>'stopped')
      end

      find('input[value="Pause All"]').click
    end

    scenario 'searching for a parser'
  end
end

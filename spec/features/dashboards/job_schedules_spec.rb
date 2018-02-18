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


  context 'one off schedules' do
    before do
      allow_any_instance_of(Partner).to receive(:update_apis)
      allow_any_instance_of(Source).to receive(:update_apis)
      allow(LinkCheckRule).to receive(:create)
      expect(HarvestSchedule).to receive(:all).and_return([one_off_schedule])

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

    scenario 'displayes one off schedule details' do
      one_off_schedule.id = 1
      visit environment_harvest_schedules_path(environment: 'staging')

       expect(page.has_content?(one_off_schedule.parser.name)).to be true
       expect(page.has_content?(I18n.l(one_off_schedule.start_time, format: :long))).to be true
       expect(page.has_content?(one_off_schedule.environment)).to be true
       expect(page.has_content?(one_off_schedule.mode)).to be true
       # expect(page.has_content?(one_off_schedule)).to be true
       # expect(page.has_content?(one_off_schedule)).to be true
       # expect(page.has_content?(one_off_schedule)).to be true
    end
  end
end

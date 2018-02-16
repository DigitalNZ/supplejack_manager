# frozen_string_literal: true
require 'rails_helper'

feature 'Manage partners', type: :feature do
  let(:all_partners_page) { AllPartnersPage.new }
  let(:admin_user) { create(:user, :admin) }
  let!(:partners) { create_list(:partner, 3) }

  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    login_as(admin_user, scope: :user)
    all_partners_page.load
  end

  scenario 'See all partners' do
    expect(all_partners_page.partner_table).to have_content('Partner', count: 3)
  end

  scenario 'Create a new partner' do
    new_partner = build(:partner)

    click_link 'New Contributor'

    fill_in 'partner[name]', with: new_partner.name

    click_button 'Create a new Contributor'

    expect(all_partners_page.partner_table).to have_content('Partner', count: 4)
  end

  scenario 'Update a partner' do
    click_link 'Partner 1'

    fill_in 'partner[name]', with: 'Updated name!!'

    click_button 'Update Contributor'

    expect(all_partners_page.partner_table).to have_content('Updated name!!')
    expect(all_partners_page).to have_flash_success
  end
end

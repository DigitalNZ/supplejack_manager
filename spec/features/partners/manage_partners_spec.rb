# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Manage partners', type: :feature do
  let(:all_partners_page) { PartnersPage.new }
  let(:admin_user) { create(:user, :admin) }
  let!(:partners) do
    allow_any_instance_of(Partner).to receive(:update_apis)
    create_list(:partner, 3)
  end

  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    login_as(admin_user, scope: :user)
    all_partners_page.load
  end

  scenario 'See all partners' do
    partners.each do |partner|
      expect(all_partners_page.partner_table).to have_content(partner.name)
    end
  end

  scenario 'Create a new partner' do
    new_partner = build(:partner)

    click_link 'New Contributor'

    fill_in 'partner[name]', with: new_partner.name

    click_button 'Create a new Contributor'

    partners.each do |partner|
      expect(all_partners_page.partner_table).to have_content(partner.name)
    end
    expect(all_partners_page.partner_table).to have_content(new_partner.name)
  end

  scenario 'Update a partner' do
    click_link partners.first.name

    fill_in 'partner[name]', with: 'Updated name!!'

    click_button 'Update Contributor'

    expect(all_partners_page.partner_table).to have_content('Updated name!!')
    expect(all_partners_page).to have_flash_success
  end
end

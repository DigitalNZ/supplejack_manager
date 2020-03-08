# frozen_string_literal: true

class EditUserPage < ApplicationPage
  set_url 'users/{id}/edit'

  element :edit_user_form, '.edit_user'

  element :run_permission_select, '#user_run_harvest_partners'
  element :manage_permission_select, '#user_manage_partners'
end

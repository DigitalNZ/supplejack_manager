# frozen_string_literal: true
class AllUsersPage < ApplicationPage
  set_url 'users/'

  element :user_table, '#users'
end

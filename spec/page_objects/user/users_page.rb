# frozen_string_literal: true
class UsersPage < ApplicationPage
  set_url 'users/'

  element :user_table, '#users'
end

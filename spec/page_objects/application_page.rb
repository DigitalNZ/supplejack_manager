# frozen_string_literal: true
class ApplicationPage < SitePrism::Page
  set_url '/'

  element :flash_success, 'header .callout.success'
  element :flash_error, 'header .callout.alert'
  element :navigation, '.top-bar'
end

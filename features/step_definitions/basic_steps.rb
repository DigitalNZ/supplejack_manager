# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

module WithinHelpers
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end
end
World(WithinHelpers)

Then /^(?:|I )should be on "([^"]*)"$/ do |page_path|
  page_path, page_query = page_path.split('?')

  current_path = URI.parse(current_url).path
  current_path.should == page_path
  URI.parse(current_url).query.should == page_query if page_query
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^I should see "([^"]*)" on "([^"]*)"$/ do |value, selector|
  page.should have_selector(selector, text: value)
end

Then /^I should not see "(.*?)"$/ do |text|
  page.should have_no_content(text)
end

Then /^"([^\"]+)" should be visible$/ do |selector|
  page.find(:css, selector).should be_visible
end

Then /^"([^\"]+)" should not be visible$/ do |selector|
  page.find(:css, selector).should_not be_visible
end

Then /^I should see a link with "(.*?)"$/ do |text|
  page.should have_link(text)
end

Then /^I should see a link to "(.*?)"$/ do |href|
  page.should have_selector("a", :href => href)
end

Then /^I should see selector "(.*?)"$/ do |selector|
  page.should have_selector(selector)
end

Then /^I should not see selector "(.*?)"$/ do |selector|
  page.should_not have_selector(selector)
end

Then /take a screenshot(| and show me the page)/ do |show_me|
  page.driver.render Rails.root.join("tmp/capybara/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png")
  Then %{show me the page} if show_me.present?
end

When /^I visit "([^"]*)"$/ do |path|
  visit(path)
end

When /^(?:|I )click button "([^"]*)"$/ do |button|
  click_button(button)
end

When /^(?:|I )click (?:|the )link "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^show me the page$/ do
  save_and_open_page
end

# Form steps

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select(value, :from => field)
end

When /^(?:|I )check "([^"]*)"$/ do |field|
  check(field)
end

When /^(?:|I )uncheck "([^"]*)"$/ do |field|
  uncheck(field)
end

When /^(?:|I )(?:|should be able to )choose "([^"]*)"$/ do |field|
  choose(field)
end
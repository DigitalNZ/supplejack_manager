Given /^a user exists with:$/ do |table|
  attributes = Hash[table.hashes.map(&:values).map(&:flatten)]
  @user = FactoryGirl.create(:user, attributes)
end

Given /^I am logged in(?: as "(.*?)")?$/ do |email|
  visit new_user_session_path
  fill_in "Email", with: email
  fill_in "Password", with: "secret"
  click_button "Sign in"
end

Then /^"(.*?)" should be an admin$/ do |name|
  User.find_by(name: name).role.should eq 'admin'
end
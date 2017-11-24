Given /^a user exists with:$/ do |table|
  attributes = Hash[table.hashes.map(&:values).map(&:flatten)]
  @user = FactoryBot.create(:user, attributes)
end

Given /^I am logged in(?: as '(.*?)')?$/ do |email|
  visit new_user_session_path
  fill_in 'Email', with: email
  fill_in 'Password', with: 'secret'
  click_button 'Sign in'
end

Then /^'(.*?)' should be an admin$/ do |name|
  User.find_by(name: name).role.should eq 'admin'
end

When /^the user has '(.*?)' set to '(.*?)'$/ do |attr, value|
  if value == 'true'
    value = true
  elsif value == 'false'
    value = false
  end

  @user.update_attribute(attr.to_sym, value)
end

Then /^show me the user$/ do
  puts @user.inspect
end

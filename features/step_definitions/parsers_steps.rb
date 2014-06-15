Given /^partner and data source exist$/ do 
  LinkCheckRule.stub(:create)
  @source = FactoryGirl.create(:source) 
  @partner = @source.partner
end

Then /^I select contributor from "(.*?)" and data source from "(.*?)"$/ do |field1, field2|
  select(@partner.name, :from => field1)
  select(@source.name, :from => field2)
end
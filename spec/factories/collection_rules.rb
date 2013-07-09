# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :collection_rule, :class => 'CollectionRules' do
    collection_title "TAPHUI"
    xpath "/xpath"
    status_codes "404"
  end
end

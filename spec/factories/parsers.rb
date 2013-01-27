FactoryGirl.define do
  factory :parser do
    name      "NZ Museums"
    strategy  "xml"
    content   "class NZMuserums; end"
  end
end

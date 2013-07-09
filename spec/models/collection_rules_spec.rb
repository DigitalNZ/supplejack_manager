require 'spec_helper'

describe CollectionRules do
  let(:rule) { FactoryGirl.build(:collection_rule) }

  describe "validations" do
    it "should not be valid without a collection name" do
      rule.collection_title = nil
      rule.should_not be_valid
    end
  end
end

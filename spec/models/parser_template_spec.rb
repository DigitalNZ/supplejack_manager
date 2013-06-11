require 'spec_helper'

describe ParserTemplate do

	let(:parser_template) { FactoryGirl.build(:parser_template) }

  describe "validations" do
  	[:name, :content].each do |field|
	  	it "validates the presence of #{field}" do
	  	  parser_template.send("#{field}=", nil)
	  	  parser_template.should_not be_valid
	  	end
	  end

	  it "validates the uniquness of name" do
	  	FactoryGirl.create(:parser_template, name: "xml", content: "Bob")
	  	parser_template.name = "xml"
	  	parser_template.content = "jim"
	  	parser_template.should_not be_valid
	  end
  end
end

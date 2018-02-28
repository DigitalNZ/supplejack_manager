require 'rails_helper'

describe ParserTemplate do
	let(:parser_template) { build(:parser_template) }

  describe 'validations' do
  	[:name, :content].each do |field|
	  	it "validates the presence of #{field}" do
	  	  parser_template.send("#{field}=", nil)
	  	  expect(parser_template).not_to be_valid
	  	end
	  end

	  it 'validates the uniquness of name' do
	  	create(:parser_template, name: 'xml', content: 'Bob')
	  	parser_template.name = 'xml'
	  	parser_template.content = 'jim'
	  	expect(parser_template).not_to be_valid
	  end
  end
end

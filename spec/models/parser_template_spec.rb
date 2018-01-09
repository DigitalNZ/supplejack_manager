# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

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

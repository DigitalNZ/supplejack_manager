# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParserTemplate do

  let(:parser_template) { build(:parser_template) }

  describe 'validations' do
    %i[name content].each do |field|
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

  describe '#user' do
    let(:user)            { create(:user) }
    let(:parser_template) { create(:parser_template, user_id: user.id) }

    it 'returns the user that is associated with the parser template' do
      expect(parser_template.user).to eq user
    end

    it 'does not fail if the user has been deleted' do
      user.destroy
      expect(parser_template.user).to eq nil
    end
  end
end

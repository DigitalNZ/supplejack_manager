# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParserLinter do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  let(:source)   { create(:source) }
  let(:parser)   { create(:parser, source_id: source) }

  describe 'linting result' do
    let(:linter) { ParserLinter.new(parser).lint }

    it 'has warnings' do
      expect(linter.warnings[0]).to include '[Correctable] Style/FrozenStringLiteralComment: Missing frozen string literal comment'
    end

    it 'has counts' do
      expect(linter.warnings_count).to eq '4 offenses detected'
    end
  end
end

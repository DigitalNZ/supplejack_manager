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

  describe 'linting parser' do
    let(:warnings) { ParserLinter.new(parser).lint }

    it 'returns warnings' do
      expect(warnings).to include '[Correctable] Style/FrozenStringLiteralComment: Missing frozen string literal comment'
      expect(warnings).to include '[Correctable] Layout/TrailingEmptyLines: Final newline missing'
      expect(warnings).to include '2 offenses detected, 2 offenses auto-correctable'
    end
  end
end

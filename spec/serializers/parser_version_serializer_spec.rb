# frozen_string_literal: true

RSpec.describe ParserVersionSerializer do
  let(:source) { create(:source) }
  let(:parser) { create(:parser, source_id: source) }
  let(:version) { create(:version, versionable: parser) }

  describe '#attributes' do

  end
end

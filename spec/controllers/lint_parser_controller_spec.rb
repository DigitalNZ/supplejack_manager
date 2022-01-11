# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LintParserController do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  let(:source)  { create(:source) }
  let(:parser)  { create(:parser, source_id: source) }
  let(:user)    { create(:user, :admin) }

  before { sign_in user }

  describe 'GET show' do
    before { get :show, params: { id: parser.id } }

    it 'assigns parser' do
      expect(assigns(:parser)).to eq parser
    end

    it 'assigns rubocop linter with warnings' do
      expect(assigns(:linter).warnings.first).to include 'Style/FrozenStringLiteralComment: Missing frozen string literal comment'
    end

    it 'assigns rubocop linter with warnings count' do
      expect(assigns(:linter).warnings_count).to include 'offenses detected'
    end
  end
end

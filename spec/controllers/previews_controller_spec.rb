# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PreviewsController do
  let(:parser) { build(:parser) }
  let(:preview) { build(:preview, parser_id: parser.id) }
  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe 'GET show' do
    it 'should find the preview object' do
      allow(LinkCheckRule).to receive(:create)

      expect(Preview).to receive(:find).with(preview.id.to_s) { preview }
      expect(Parser).to receive(:find).with(parser.id) { parser }
      get :show, params: { id: preview.id, format: 'turbo_stream' }
      expect(assigns(:preview)).to eq preview
    end
  end
end

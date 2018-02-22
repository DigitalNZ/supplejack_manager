
require 'spec_helper'

describe PreviewsController do
  let(:preview) { build(:preview) }
  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe 'GET show' do
    it 'should find the preview object' do
      expect(Preview).to receive(:find).with(preview.id.to_s) { preview }
      get :show, params: { id: preview.id, format: 'js' }
      expect(assigns(:preview)).to eq preview
    end
  end
end

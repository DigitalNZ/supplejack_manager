# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'rails_helper'

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

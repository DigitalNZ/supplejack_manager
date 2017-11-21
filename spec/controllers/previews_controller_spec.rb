# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe PreviewsController do
  let(:preview) { instance_double(Preview, id: '123').as_null_object }
  let(:user) { instance_double(User, id: '1234').as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
  end

  describe 'GET show' do
    it 'should find the preview object' do
      expect(Preview).to receive(:find).with(preview.id.to_s) { preview }
      get :show, id: preview.id, format: 'js'
      expect(assigns(:preview)).to eq preview
    end
  end
end

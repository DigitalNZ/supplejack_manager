# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe AbstractJobsController do
  before(:each) do
    sign_in create(:user)
  end

  describe 'GET index' do
    it 'returns active abstract jobs' do
      expect(AbstractJob).to receive(:search).with(hash_including('status' => 'active'))
      get :index, params: { status: 'active', environment: 'staging' }
    end
  end
end

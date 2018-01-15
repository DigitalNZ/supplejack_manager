# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe CollectionStatisticsController do
  let(:collection_statistics) { build(:collection_statistics) }

  before(:each) do
    sign_in create(:user)
  end

  describe 'GET index' do
    it 'should get all of the collection statistics' do
      expect(CollectionStatistics).to receive(:all) { [collection_statistics] }
      get :index, params: { environment: 'staging' }
      expect(assigns(:collection_statistics)).to eq "#{Time.zone.today.to_s}" => {:suppressed=>1, :activated=>0, :deleted=>0}
    end
  end

  describe 'GET show' do
    it 'should do a find :all with the day' do
      expect(CollectionStatistics).to receive(:find).with(:all, params: { collection_statistics: {day: Date.today.to_s} }) { collection_statistics }
      get :show, params: { id: Date.today.to_s, environment: 'staging' }
      expect(assigns(:collection_statistics)).to eq collection_statistics
    end
  end
end

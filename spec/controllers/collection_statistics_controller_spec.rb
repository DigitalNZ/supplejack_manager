# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe CollectionStatisticsController do

	let(:collection_statistics) { double(:collection_statistics) }
	let(:user) { instance_double(User).as_null_object }
	let(:stats_index){ double(:stats_index) }

  before(:each) do
    allow(controller).to receive(:authenticate_user!) { true }
    allow(controller).to receive(:current_user) { user }
  end

	describe "GET index" do
		it "should get all of the collection statistics" do
			expect(CollectionStatistics).to receive(:all) { [collection_statistics] }
			expect(CollectionStatistics).to receive(:index_statistics).with([collection_statistics]) { stats_index }
		  get :index, environment: "staging"
		  expect(assigns(:collection_statistics)).to eq stats_index
		end
	end

	describe "GET show" do
		it "should do a find :all with the day" do
		  expect(CollectionStatistics).to receive(:find).with(:all, params: { collection_statistics: {day: Date.today.to_s} }) { collection_statistics }
		  get :show, id: Date.today.to_s, environment: "staging"
		  expect(assigns(:collection_statistics)).to eq collection_statistics
		end
	end

end

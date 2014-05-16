# The majority of the Supplejack code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components licensed under the GPL or MIT licenses or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require 'spec_helper'

describe CollectionStatisticsController do

	let(:collection_statistics) { mock(:collection_statistics) }
	let(:user) { mock_model(User).as_null_object }
	let(:stats_index){ mock(:stats_index) }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
  end

	describe "GET index" do
		it "should get all of the collection statistics" do
			CollectionStatistics.should_receive(:all) { [collection_statistics] }
			CollectionStatistics.should_receive(:index_statistics).with([collection_statistics]) { stats_index }
		  get :index, environment: "staging"
		  assigns(:collection_statistics).should eq stats_index
		end
	end

	describe "GET show" do
		it "should do a find :all with the day" do
		  CollectionStatistics.should_receive(:find).with(:all, params: { collection_statistics: {day: Date.today.to_s} }) { collection_statistics }
		  get :show, id: Date.today.to_s, environment: "staging"
		  assigns(:collection_statistics).should eq collection_statistics
		end
	end

end

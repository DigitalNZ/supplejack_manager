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
		  get :index
		  assigns(:collection_statistics).should eq stats_index
		end
	end

	describe "GET show" do
		it "should do a find :all with the day" do
		  CollectionStatistics.should_receive(:find).with(:all, params: { collection_statistics: {day: Date.today.to_s} }) { collection_statistics }
		  get :show, id: Date.today.to_s
		  assigns(:collection_statistics).should eq collection_statistics
		end
	end

end

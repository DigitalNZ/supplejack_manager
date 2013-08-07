require 'spec_helper'

describe PreviewsController do
	let(:preview) { mock_model(Preview, id: "123").as_null_object }
	let(:user) { mock_model(User, id: "1234").as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
  end

	describe "GET show" do
		it "should find the preview object" do
		  Preview.should_receive(:find).with(preview.id.to_s) { preview }
		  get :show, id: preview.id
		  assigns(:preview).should eq preview
		end
	end
end
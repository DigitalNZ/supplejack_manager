# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require 'spec_helper'

describe SourcesController do
  before do
    Partner.any_instance.stub(:update_apis)
    Source.any_instance.stub(:update_apis)
    LinkCheckRule.stub(:create)
  end

  let(:partner) {FactoryGirl.create(:partner)}
  def valid_attributes
    FactoryGirl.attributes_for(:source, partner_id: partner.id)
  end

  before(:each) do
    controller.stub(:authenticate_user!) { true }
  end

  describe "GET index" do
    it "assigns all sources as @sources" do
      source = Source.create! valid_attributes
      get :index, {}
      assigns(:sources).should eq([source])
    end
  end

  describe "GET new" do
    it "assigns a new source as @source" do
      get :new, {}
      assigns(:source).should be_a_new(Source)
    end
  end

  describe "GET edit" do
    it "assigns the requested source as @source" do
      source = Source.create! valid_attributes
      get :edit, {:id => source.to_param}
      assigns(:source).should eq(source)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Source" do
        expect {
          post :create, {:source => valid_attributes}
        }.to change(Source, :count).by(1)
      end

      it "assigns a newly created source as @source" do
        post :create, {:source => valid_attributes}
        assigns(:source).should be_a(Source)
        assigns(:source).should be_persisted
      end

      it "redirects to the sources page" do
        post :create, {:source => valid_attributes}
        response.should redirect_to sources_path
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved source as @source" do
        Source.any_instance.stub(:save).and_return(false)
        post :create, {:source => {  }}
        assigns(:source).should be_a_new(Source)
      end

      it "re-renders the 'new' template" do
        Source.any_instance.stub(:save).and_return(false)
        post :create, {:source => {  }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested source" do
        source = Source.create! valid_attributes
        Source.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => source.to_param, :source => { "these" => "params" }}
      end

      it "assigns the requested source as @source" do
        source = Source.create! valid_attributes
        put :update, {:id => source.to_param, :source => valid_attributes}
        assigns(:source).should eq(source)
      end

      it "redirects to the sources index" do
        source = Source.create! valid_attributes
        put :update, {:id => source.to_param, :source => valid_attributes}
        response.should redirect_to sources_path
      end
    end

    describe "with invalid params" do
      it "assigns the source as @source" do
        source = Source.create! valid_attributes
        Source.any_instance.stub(:save).and_return(false)
        put :update, {:id => source.to_param, :source => {  }}
        assigns(:source).should eq(source)
      end

      it "re-renders the 'edit' template" do
        source = Source.create! valid_attributes
        Source.any_instance.stub(:save).and_return(false)
        put :update, {:id => source.to_param, :source => {  }}
        response.should render_template("edit")
      end
    end

    describe "GET reindex" do
      it "calls reindex on api" do
        source = Source.create! valid_attributes
        RestClient.should_receive(:get).with("#{ENV['API_HOST']}/sources/#{source.id}/reindex?date=2013-09-12T01:49:51.067Z")
        get :reindex,  {:id => source.to_param, env: :test, date: "2013-09-12T01:49:51.067Z", format: :js}
      end
    end
  end
end

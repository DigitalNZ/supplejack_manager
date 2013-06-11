require 'spec_helper'

describe ParserTemplatesController do

	let(:parser_template) { mock_model(ParserTemplate, name: "Copyright").as_null_object }
	let(:user) { mock_model(User).as_null_object }

	before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
  end

	describe "GET 'index'" do
		it "should get all of the parser templates" do
		  ParserTemplate.should_receive(:all) { [parser_template] }
		  get :index
		  assigns(:parser_templates).should eq [parser_template]
		end
	end

	describe "GET 'new'" do
		it "creates a new parser template" do
			ParserTemplate.should_receive(:new) { parser_template }
			get :new
			assigns(:parser_template).should eq parser_template
		end
	end

	describe "GET 'edit'" do
		it "finds the parser_template" do
		  ParserTemplate.should_receive(:find) { parser_template }
		  get :edit, id: parser_template.id
		  assigns(:parser_template).should eq parser_template
		end
	end

	describe "POST 'create'" do
		it "should make a new parser template and assign it with a user id " do
		  ParserTemplate.should_receive(:new) { parser_template }
		  post :create, parser_template: { name: "template", content: "content" }
		  assigns(:parser_template) { parser_template }
		end

		it "should redirect_to the edit page." do
			ParserTemplate.stub(:new) { parser_template }
		  post :create, parser_template: { name: "template", content: "content" }
		  response.should redirect_to edit_parser_template_path(parser_template.id)
		end

		context "parser_template not valid" do
			it "should render the new template" do
			  ParserTemplate.stub(:new) { parser_template }
			  parser_template.stub(:save) { false }
			  post :create, parser_template: { name: "template", content: "content" }
			  response.should render_template(:new)
			end
		end
	end

	describe "PUT 'update'" do
		it "should find the parser_template and update the user" do
		  ParserTemplate.should_receive(:find) { parser_template }
		  put :update, id: parser_template.id, parser_template: { name: "title", content: "new content" }
		  assigns(:parser_template) { parser_template }
		end

		it "should redirect_to the edit path" do
		  ParserTemplate.stub(:find) { parser_template }
		  put :update, id: parser_template.id, parser_template: { name: "title", content: "new content" }
		  response.should redirect_to edit_parser_template_path(parser_template.id)
		end

		it "updates all the attributes" do
			ParserTemplate.stub(:find) { parser_template }
			parser_template.should_receive(:update_attributes).with({"name" => "title", "content" => "new content" })
		  put :update, id: parser_template.id, parser_template: { name: "title", content: "new content" }
		end

		context "parser_template not valid" do
			it "should render the edit template" do
			  ParserTemplate.stub(:find) { parser_template }
			  parser_template.stub(:update_attributes) { false }
			  post :update, id: parser_template.id, parser_template: { name: "template", content: "content" }
			  response.should render_template(:edit)
			end
		end
	end

	describe "DELETE 'destroy'" do
		it "finds the parser template and destroys it" do
		  ParserTemplate.should_receive(:find) { parser_template }
		  delete :destroy, id: parser_template.id
		  response.should redirect_to parser_templates_path
		end
	end

end

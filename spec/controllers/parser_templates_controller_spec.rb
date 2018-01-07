# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe ParserTemplatesController do
	# let(:parser_template) { instance_double(ParserTemplate, name: "Copyright").as_null_object }

  let(:parser_template) { create(:parser_template) }
  let(:user)            { create(:user, :admin) }

	before(:each) do
    sign_in user
  end

	describe "GET 'index'" do
		it 'should get all of the parser templates' do
		  expect(ParserTemplate).to receive(:all) { [parser_template] }
		  get :index
		  expect(assigns(:parser_templates)).to eq [parser_template]
		end
	end

	describe "GET 'new'" do
		it 'creates a new parser template' do
			get :new
			expect(assigns(:parser_template)).to be_a_new(ParserTemplate)
		end
	end

	describe "GET 'edit'" do
		it 'finds the parser_template' do
		  expect(ParserTemplate).to receive(:find) { parser_template }
		  get :edit, id: parser_template.id
		  expect(assigns(:parser_template)).to eq parser_template
		end
	end

	describe "POST 'create'" do
		it 'should make a new parser template and assign it with a user id' do
		  post :create, parser_template: { name: "template", content: "content" }
		  assigns(:parser_template) { parser_template }
		end

		it 'should redirect_to the edit page.' do
		  post :create, parser_template: { name: "template", content: "content" }
		  expect(response).to redirect_to edit_parser_template_path(ParserTemplate.last.id)
		end

		context "parser_template not valid" do
			it "should render the new template" do
			  expect_any_instance_of(ParserTemplate).to receive(:save) { false }
			  post :create, parser_template: { name: 'template', content: 'content' }
			  expect(response).to render_template(:new)
			end
		end
	end

	describe "PUT 'update'" do
		it "should find the parser_template and update the user" do
		  expect(ParserTemplate).to receive(:find) { parser_template }
		  put :update, id: parser_template.id, parser_template: { name: "title", content: "new content" }
		  assigns(:parser_template) { parser_template }
		end

		it "should redirect_to the edit path" do
		  allow(ParserTemplate).to receive(:find) { parser_template }
		  put :update, id: parser_template.id, parser_template: { name: "title", content: "new content" }
		  expect(response).to redirect_to edit_parser_template_path(parser_template.id)
		end

		it "updates all the attributes" do
			allow(ParserTemplate).to receive(:find) { parser_template }
			expect(parser_template).to receive(:update_attributes).with({"name" => "title", "content" => "new content" })
		  put :update, id: parser_template.id, parser_template: { name: "title", content: "new content" }
		end

		context "parser_template not valid" do
			it "should render the edit template" do
			  allow(ParserTemplate).to receive(:find) { parser_template }
			  allow(parser_template).to receive(:update_attributes) { false }
			  post :update, id: parser_template.id, parser_template: { name: "template", content: "content" }
			  expect(response).to render_template(:edit)
			end
		end
	end

	describe "DELETE 'destroy'" do
		it "finds the parser template and destroys it" do
		  expect(ParserTemplate).to receive(:find) { parser_template }
		  delete :destroy, id: parser_template.id
		  expect(response).to redirect_to parser_templates_path
		end
	end

end

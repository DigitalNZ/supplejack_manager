# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require "spec_helper"

describe ApplicationHelper do

	describe "#pretty_format" do

		let(:raw_data) { {bill: "bob"}.to_json  }
		let(:parser) { mock(:parser) }

		context "parser found" do

			it "should find the parser & get the format" do
				Parser.should_receive(:find).with("abc123") { parser }
				parser.should_receive(:xml?)
			  helper.pretty_format("abc123", raw_data)
			end

			before do 
				Parser.stub(:find) { parser }
			end

			context "json" do
				before { parser.stub(:xml?) { false } }

				it "should use coderay to format the raw_data" do
				  CodeRay.should_receive(:scan).with("{\n  \"bill\": \"bob\"\n}", :json) { mock(:output).as_null_object }
				  helper.pretty_format("abc123", raw_data)
				end

				it "should pretty generate the JSON if it is json" do
					JSON.should_receive(:pretty_generate).with({"bill"=>"bob"})
				  helper.pretty_format("abc123", raw_data)
				end
			end

			context "xml" do
				before { parser.stub(:xml?) { true } }

				it "should not pretty generate the XML" do
				  JSON.should_not_receive(:pretty_generate).with(raw_data)
				  helper.pretty_format("abc123", raw_data)
				end
			end
		end

		context "parser not found" do
			it "should return the raw data if the parser is not found" do
			  helper.pretty_format("abc123", raw_data).should eq raw_data
			end
		end

	end

	describe "safe_users_path" do
		context "admin user" do
			it "should be able to access users_path" do
		  	helper.stub(:current_user) { double(:user, admin?: true) }
		  	helper.safe_users_path.should eq users_path
			end
		end

		context "standard user" do
			it "should not be able to access users_path" do
		  	helper.stub(:current_user) { double(:user, admin?: false) }
		  	helper.safe_users_path.should eq root_path
			end
		end
	end

	describe "can_show_button" do
		context "authorised" do
			it "should return empty string" do
			 helper.stub(:can?) { true }
			 helper.can_show_button(:create, Source).should eq ''
			end
		end
		
		context "unauthorised" do
			it "should return disabled" do
			 helper.stub(:can?) { false }
			 helper.can_show_button(:create, Source).should eq 'disabled'
			end
		end
	end
end
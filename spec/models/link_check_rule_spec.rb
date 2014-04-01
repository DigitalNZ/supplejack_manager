require "spec_helper"

describe LinkCheckRule do
	let(:link_check_rule) { LinkCheckRule.new }
	let(:source) { FactoryGirl.create(:source, source_id: "tapuhi") }

	@link_check_rule  = { :link_check_rule => { source_id: "tapuhi", active: true } }.to_json

  ActiveResource::HttpMock.respond_to do |mock|
    mock.post "/link_check_rule.json", {"Authorization" => "Basic MTIzNDU6", "Content-Type" => "application/json"}, @link_check_rule 
  end

  before do 
    Partner.any_instance.stub(:update_apis)
    Source.any_instance.stub(:update_apis)
    LinkCheckRule.stub(:create)
  end

	describe "source" do

		before { link_check_rule.stub(:source_id) { 'abc123' } }

		it "returns the source the collection rules are related to" do
			Source.should_receive(:find).with( 'abc123') { source }
		  link_check_rule.source.should eq source
		end

		it "returns nil if it can not find the source" do
		  link_check_rule.source.should be_nil
		end
	end
end
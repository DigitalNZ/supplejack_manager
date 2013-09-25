require "spec_helper"

describe CollectionRules do
	let(:collection_rules) { CollectionRules.new }
	let(:source) { FactoryGirl.create(:source, source_id: "tapuhi") }

	@collection_rules  = { :collection_rules => { source_id: "tapuhi", active: true } }.to_json

  ActiveResource::HttpMock.respond_to do |mock|
    mock.post "/collection_rules.json", {"Authorization" => "Basic MTIzNDU6", "Content-Type" => "application/json"}, @collection_rules 
  end

  before do 
    Partner.any_instance.stub(:update_apis)
    Source.any_instance.stub(:update_apis)
  end

	describe "source" do

		before { collection_rules.stub(:source_id) { 'tapuhi' } }

		it "returns the source the collection rules are related to" do
			Source.should_receive(:find_by).with(source_id: 'tapuhi') { source }
		  collection_rules.source.should eq source
		end

		it "returns nil if it can not find the source" do
		  collection_rules.source.should be_nil
		end
	end
end
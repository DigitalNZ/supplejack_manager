require "spec_helper"

describe LinkCheckRule do
	let(:link_check_rule) { LinkCheckRule.new }
	let(:source) { create(:source, source_id: "source_id") }

	@link_check_rule  = { :link_check_rule => { source_id: "source_id", active: true } }.to_json

  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

	describe "source" do

		before { allow(link_check_rule).to receive(:source_id) { 'abc123' } }

		it "returns the source the collection rules are related to" do
			expect(Source).to receive(:find).with( 'abc123') { source }
		  expect(link_check_rule.source).to eq source
		end

		it "returns nil if it can not find the source" do
		  expect(link_check_rule.source).to be_nil
		end
	end
end

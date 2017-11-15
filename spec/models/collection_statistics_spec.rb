# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe CollectionStatistics do

	let!(:stats_obj_1) { mock(:stats, day: Date.today, suppressed_count: 2, activated_count: 3, deleted_count: 3) }
	let!(:stats_obj_2) { mock(:stats, day: Date.today, suppressed_count: 1, activated_count: 1, deleted_count: 2) }
	let!(:stats_obj_3) { mock(:stats, day: Date.today, suppressed_count: 5, activated_count: 2, deleted_count: 4) }

	it "should convert the active resource object into a hash of dates with counts" do
	  index_stats = CollectionStatistics.index_statistics([stats_obj_1, stats_obj_2, stats_obj_3])
	  index_stats[Date.today][:suppressed].should eq(8)
	  index_stats[Date.today][:activated].should eq(6)
	  index_stats[Date.today][:deleted].should eq(9)
	end

	it "should handle an empty array" do
	  index_stats = CollectionStatistics.index_statistics([])
	  index_stats.should eq({})
	end

	@collection_statistics  = { :collection_rules => { source_id: "source_id" } }.to_json

  ActiveResource::HttpMock.respond_to do |mock|
    mock.post "/collection_rules.json", {"Authorization" => "Basic MTIzNDU6", "Content-Type" => "application/json"}, @collection_statistics
  end

	describe "source" do

		let(:collection_statistics) { CollectionStatistics.new }
		let(:source) { FactoryGirl.create(:source) }

		before do
      Partner.any_instance.stub(:update_apis)
      Source.any_instance.stub(:update_apis)
      LinkCheckRule.stub(:create)
      collection_statistics.stub(:source_id) { 'source_id' }
		end

		it "shound find the source with the collection statistics source id" do
			Source.should_receive(:find_by).with(source_id: 'source_id') { source }
		  collection_statistics.source.should eq source
		end

		it "returns nil if it can not find the source" do
		  collection_statistics.source.should be_nil
		end
	end

end

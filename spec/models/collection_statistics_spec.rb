# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe CollectionStatistics do
	let!(:stats_obj_1) { build(:collection_statistics, day: Date.today, suppressed_count: 2, activated_count: 3, deleted_count: 3) }
	let!(:stats_obj_2) { build(:collection_statistics, day: Date.today, suppressed_count: 1, activated_count: 1, deleted_count: 2) }
	let!(:stats_obj_3) { build(:collection_statistics, day: Date.today, suppressed_count: 5, activated_count: 2, deleted_count: 4) }

	it "should convert the active resource object into a hash of dates with counts" do
	  index_stats = CollectionStatistics.index_statistics([stats_obj_1, stats_obj_2, stats_obj_3])
	  expect(index_stats[Date.today][:suppressed]).to eq(8)
	  expect(index_stats[Date.today][:activated]).to eq(6)
	  expect(index_stats[Date.today][:deleted]).to eq(9)
	end

	it "should handle an empty array" do
	  index_stats = CollectionStatistics.index_statistics([])
	  expect(index_stats).to eq({})
	end

	@collection_statistics  = { :collection_rules => { source_id: "source_id" } }.to_json

	describe "source" do

		let(:collection_statistics) { CollectionStatistics.new }
		let(:source) { create(:source) }

		before do
      allow_any_instance_of(Partner).to receive(:update_apis)
      allow_any_instance_of(Source).to receive(:update_apis)
      allow(LinkCheckRule).to receive(:create)
      allow(collection_statistics).to receive(:source_id) { 'source_id' }
		end

		it "shound find the source with the collection statistics source id" do
			expect(Source).to receive(:find_by).with(source_id: 'source_id') { source }
		  expect(collection_statistics.source).to eq source
		end

		it "returns nil if it can not find the source" do
		  expect(collection_statistics.source).to be_nil
		end
	end

end

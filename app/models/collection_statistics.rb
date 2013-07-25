class CollectionStatistics < ActiveResource::Base

  self.site = ENV["WORKER_HOST"]
  self.user = ENV["WORKER_API_KEY"]

  def self.index_statistics(statistics)

		index_statistics = Hash.new

		statistics.each do |stats_item|
			index_statistics[stats_item.day] ||= Hash.new(0)
			index_statistics[stats_item.day][:suppressed] += stats_item.suppressed_count
			index_statistics[stats_item.day][:activated] += stats_item.activated_count
			index_statistics[stats_item.day][:deleted] += stats_item.deleted_count
		end

		index_statistics
  end

end
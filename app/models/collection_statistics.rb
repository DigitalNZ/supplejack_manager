# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

class CollectionStatistics < ActiveResource::Base
  include EnvironmentHelpers

  self.site = ENV["WORKER_HOST"]
  headers['Authorization'] = "Token token=#{ENV['WORKER_KEY']}"


  def self.index_statistics(statistics)

		index_statistics = Hash.new

		statistics = statistics.sort_by(&:day).reverse

		statistics.each do |stats_item|
			index_statistics[stats_item.day] ||= Hash.new(0)
			index_statistics[stats_item.day][:suppressed] += stats_item.suppressed_count
			index_statistics[stats_item.day][:activated] += stats_item.activated_count
			index_statistics[stats_item.day][:deleted] += stats_item.deleted_count
		end

		index_statistics
  end

  def source
  	Source.find_by(source_id: self.source_id) rescue nil
  end

end

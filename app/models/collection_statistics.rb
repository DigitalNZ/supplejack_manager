# frozen_string_literal: true

class CollectionStatistics < ActiveResource::Base
  include EnvironmentHelpers

  self.site = ENV['WORKER_HOST']
  headers['Authorization'] = "Token token=#{ENV['WORKER_KEY']}"

  def self.index_statistics(statistics)
    index_statistics = Hash.new
    statistics = statistics.sort_by(&:day)

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

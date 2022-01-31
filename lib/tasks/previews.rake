# frozen_string_literal: true

namespace :previews do
  desc 'Deletes previews created'
  task purge: :environment do
    Preview.where(:created_at.lte => 7.days.ago).delete_all
  end
end

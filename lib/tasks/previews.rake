# frozen_string_literal: true

namespace :previews do
  desc 'Deletes previews created before 30 minutes'
  task purge: :environment do
    Preview.where(:created_at.lte => 30.minutes.ago).delete_all
  end
end

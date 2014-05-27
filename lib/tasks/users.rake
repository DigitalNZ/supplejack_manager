namespace :users do
  desc "Set all existing users to active"
  task :save => :environment do
    User.all.map(&:save!)
  end
end

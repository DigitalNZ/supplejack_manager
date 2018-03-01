
namespace :docker do
  desc 'Seed data with default user'
  task :seed => :environment do
    unless User.where(authentication_token: 'managerkey').first
      user = User.create({
        name: 'Harvester',
        email: 'info@digitalnz.org',
        password: 'password',
        password_confirmation: 'password',
        role: 'admin'
      })

      user.authentication_token = 'managerkey'
      user.save
    end
  end
end

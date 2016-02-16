namespace :docker do
  desc 'Seed data with default user'
  task :seed => :environment do
    u = User.create({
      name: 'Harvester',
      email: 'info@boost.co.nz',
      password: 'password',
      password_confirmation: 'password',
      role: 'admin'
    })
  end
end

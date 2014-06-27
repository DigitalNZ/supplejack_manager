namespace :parsers do
  desc "Set all existing parser's data_type to record"
  task :set_data_type => :environment do
    Parser.all.each {|p| p.update_attribute(:data_type, 'record') }
  end
end

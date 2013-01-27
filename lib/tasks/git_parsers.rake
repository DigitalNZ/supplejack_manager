namespace :parsers do
  
  desc "Migrate parsers from Git to MongoDB"
  task :migrate => :environment do
    GitParser.all.each do |git_parser|
      Parser.create(name: git_parser.loader.parser_class_name.gsub(/([A-Z])+/, ' \1').strip,
                    strategy: git_parser.strategy,
                    content: git_parser.data)
    end
  end
end
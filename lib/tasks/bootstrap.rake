require File.dirname(__FILE__) + '/../../config/environment'

namespace :db do
    
  desc "Bootstraps the database with EVE Data"
  task :bootstrap do
    Dir['db/ccp-bootstrap/*.sql'].each do |file|
      puts "Processing #{file}..."
      sql_file = File.open( file ).read
      sql_file.split(';').each do |statement|
        ActiveRecord::Base.connection.execute( statement )
      end
    end
  end
    
end
require File.dirname(__FILE__) + '/../../config/environment'
require 'reve'

namespace :api do
  namespace :alliances do
    
    desc "Updates the list of alliances."
    task :refresh do
      Reve::API.new.alliances.first do |alliance|
        attributes = {:name => alliance.name, 
                      :short_name => alliance.short_name,
                      :eve_id => alliance.id,
                      :executor_corp_id => alliance.executor_corp_id,
                      :start_date => alliance.start_date}
        Alliance.create( attributes ) unless Alliance.find_by_eve_id( alliance.id )
      end
    end
    
  end
end
require File.dirname(__FILE__) + '/../../config/environment'
require 'reve'
require 'hpricot'
require 'open-uri'

namespace :api do
  namespace :alliances do
    
    desc "Updates the list of alliances."
    task :refresh do
      Reve::API.new.alliances.each do |alliance|
        attributes = {:name => alliance.name, 
                      :short_name => alliance.short_name,
                      :eve_id => alliance.id,
                      :executor_corp_id => alliance.executor_corp_id,
                      :start_date => alliance.start_date}
        Alliance.create( attributes ) unless Alliance.find_by_eve_id( alliance.id )
      end
    end
    
    desc "Updates the Alliance Logo Mappings"
    task :logos do
      doc = Hpricot(open("http://wiki.eve-id.net/IconToAllianceID_Mappings"))
      (doc/"pre").inner_html.each do |line|
        alliance_id, logo_id = line.split(" ")
        if alliance = Alliance.find_by_eve_id( alliance_id )
          alliance.update_attributes(:icon => logo_id)
        end
      end
    end
        
  end
end
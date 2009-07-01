module PilotHelper
  def system_name( pilot )
    pilot.solar_system.name
  end
  
  def system_security_status( pilot )
    sprintf("%.2f", @kill.victim.solar_system.security)
  end
  
  def region_name( pilot )
    pilot.solar_system.region.name
  end
  
  def solar_system_name_and_region( pilot )
    [system_search_link(pilot), content_tag(:br), "(#{region_search_link( pilot )})"]
  end
  
  def victor_pilot_name( pilot )
    p = []
    p << pilot_name( pilot )
    p << "&nbsp;" + image_tag("finalblow.gif", :alt => 'Laid the final blow', :title => 'Laid the final blow', :style => 'vertical-align: bottom;') if pilot.laid_final_blow
    p
  end

  def pilot_name( pilot )
    link_to pilot.name, player_search_url( pilot.name )
  end
  
  def alliance_name( pilot )
    name = pilot.alliance.nil? ? 'NONE' : pilot.alliance.name
  end
  
  def alliance_link( pilot )
    link_to alliance_name( pilot ), alliance_search_url( alliance_name( pilot ) )
  end
  
  def alliance_icon( pilot, size = "32" )
    icon = pilot.alliance.nil? ? '01_01' : pilot.alliance.icon
    image_tag("icons/alliances/32_32/icon#{icon}.png")
  end
  
  def alliance_name_and_logo( pilot )
    icon = pilot.alliance.nil? ? '01_01' : pilot.alliance.icon
    link_to alliance_name( pilot ), alliance_search_url( alliance_name( pilot ) ), :class => 'icon', :style => "background-image: url('/images/icons/alliances/32_32/icon#{icon}.png')"
  end  
  
  def corporation_name( pilot )
    link_to pilot.corporation_name, corporation_search_url( pilot.corporation_name )
  end
  
  def ship_name( pilot )
    pilot.ship.name unless pilot.ship.name.nil?
  end
  
  def ship_name_and_wiki_link( pilot, options = {})
    link = "http://wiki.goonfleet.com/index.php?title=#{pilot.ship.name}"
    icon = pilot.alliance.nil? ? '01_01' : pilot.alliance.icon
    link_to ship_name( pilot ), link, :class => 'icon', :style => "background-image: url('/images/icons/ships/32_32/#{pilot.ship.id}.png')"
  end
  
  def ship_icon( pilot, size = "32")
    image_tag("icons/ships/#{ size + '_' + size }/#{pilot.ship.id}.png", :alt => pilot.ship.name, :width => size, :height => size, :title => pilot.ship.name, :class => 'icon')
  end
  
  def damage_count( pilot )
    [pilot.damage, content_tag(:br), '(', sprintf("%.2f", (pilot.damage.to_f * 100) / pilot.kill.total_damage.to_f), '%)']
  end
  
  def weapon_name( pilot )
    pilot.weapon_name
  end
  
  def pilot_search_link( pilot )
    link_to pilot_name( pilot ), player_search_url( pilot_name( pilot ) )
  end
  
  def corporation_search_link( pilot )
    link_to corporation_name( pilot ), corporation_search_url( corporation_name( pilot ) )
  end
  
  def alliance_search_link( pilot )
    link_to alliance_name( pilot ), alliance_search_url( alliance_name( pilot ) )
  end
  
  def ship_search_link( pilot )
    link_to ship_name( pilot ), ship_search_url( ship_name( pilot ) )
  end
  
  def system_search_link( pilot )
    link_to system_name( pilot ), system_search_url( system_name( pilot ) )
  end
  
  def region_search_link( pilot )
    link_to region_name( pilot ), region_search_url( region_name( pilot ) )
  end
  
end
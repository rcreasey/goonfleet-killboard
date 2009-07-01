module KillsHelper
  
  def kill_table_header(columns, class_prefix = '')
    cells = []
    columns.map {|columnName| cells << content_tag(:th, columnName, :class => "list#{ class_prefix + columnName}")}
    content_tag(:thead, content_tag(:tr, cells))
  end
  
  def kill_list_table(name, header_columns, data, options = {})
    options[:pagable] ||= true
    table = []
    table << kill_table_header( header_columns )
    body = []
    data.each do |d|
      body << kill_list_row(d)
    end
    table << body
    table << content_tag(:tfoot, content_tag(:tr, content_tag(:td, will_paginate(data), :colspan => header_columns.length))) if options[:pagable]
    content_tag(:table, table, :cellspacing => 0, :cellpadding => 0, :summary => name)
  end

  def kill_list_row(kill)
    cells = []
    cells << content_tag(:td, posted_time( kill ))
    cells << content_tag(:td, solar_system_name_and_region( kill.victim ))
    cells << content_tag(:td, pilot_name( kill.victim ))
    cells << content_tag(:td, alliance_name_and_logo( kill.victim ))
    cells << content_tag(:td, corporation_name( kill.victim ))
    cells << content_tag(:td, ship_name_and_wiki_link( kill.victim, :icon => true ))
    cells << content_tag(:td, link_to('Details', kill_url( kill.id ), :class => 'details'))
  
    content_tag(:tr, cells, :class => cycle('odd', 'even'))
  end
  
  def kill_participants_table(name, header_columns, data)
    table = []
    table << kill_table_header( header_columns )
    body = []
    data.each do |d|
      body << kill_list_participant_row(d)
    end
    table << body
    content_tag(:table, table, :cellspacing => 0, :cellpadding => 0, :summary => name)
  end
  
  def kill_list_participant_row( pilot )
    cells = []
    cells << content_tag(:td, victor_pilot_name( pilot ))
    cells << content_tag(:td, corporation_name( pilot ))
    cells << content_tag(:td, alliance_name_and_logo( pilot ))
    cells << content_tag(:td, ship_name_and_wiki_link( pilot, :icon => true ))
    cells << content_tag(:td, weapon_name( pilot ))
    cells << content_tag(:td, damage_count( pilot ))
    
    content_tag(:tr, cells, :class => cycle('odd', 'even'))
  end 
  
  def kill_manifest_table( manifest )
    content = []
    manifest.each do |category, list|
      name = category.eql?(:destroyed_items) ? "Destroyed Items" : "Items Dropped"
      content << content_tag(:h4, name)
      table = []
      headers = [content_tag(:th, "Item"), content_tag(:th, "Quantity"), content_tag(:th, "Slot")]
      table << content_tag(:thead, content_tag(:tr, headers))
      body = []
      list.each do |item|
        row = [content_tag(:td, item.item_name), content_tag(:td, item.quantity), content_tag(:td, "")]
        body << content_tag(:tr, row, :class => cycle('odd', 'even'))
      end
      table << content_tag(:tbody, body)
      content << content_tag(:table, table, :cellspacing => 0, :cellpadding => 0, :summary => name)
    end
    content
  end
  
  # accessor helpers
  def kill_manifest( kill )
    require 'app/models/manifest_item'
    YAML.load( kill.manifest )
  end
  
  def posted_time( kill )
    kill.posted.strftime("%Y-%m-%d %H:%M:%S")
  end
  
  # vvv dateHelper deprecated metods
  def leading_zero_on_single_digits(number)
    number > 9 ? number : "0#{number}"
  end
  # ^^^ deprecated methods 
  
  def select_eve_hour(datetime, options = {})
    hour_options = []
    val = datetime ? (datetime.kind_of?(Fixnum) ? datetime : datetime.hour) : ''
    0.upto(23) do |hour|
      hour_options << ((val == hour) ?
        content_tag(:option, "#{leading_zero_on_single_digits(hour)}:00", :value => "#{leading_zero_on_single_digits(hour)}:00", :selected => "selected") :
        content_tag(:option, "#{leading_zero_on_single_digits(hour)}:00", :value => "#{leading_zero_on_single_digits(hour)}:00")
      )
      hour_options << "\n"
    end
    select_tag(options[:field_name] || 'hour', hour_options.join, options)
  end
  
  def select_eve_date(datetime, options)
    date_options = []
    month_names = Date::ABBR_MONTHNAMES
    month_names.unshift(nil) if month_names.size < 13
    [ datetime, datetime - 1.month, datetime - 2.months ].each do |date|
      year = date.year
      month = date.month
      month_name = month_names[month]
      start_day = datetime.month.eql?(month) ? datetime.day : Time.days_in_month(month, year)
      start_day.downto(1) do |day|
        label = "#{day}-#{month_name}-#{year}"
        date_options << content_tag(:option, label, :value => label)
        date_options << "\n"
      end
    end
    select_tag(options[:field_name] || 'date', date_options.join, options)
  end
  
  def ship_type_checkbox_list
    ""
    # .system
    #   %label{:for => 'systems'} Occurring in System:
    #   = text_field_with_auto_complete :solar_systems, :solarSystemName
  end
  
  def lookup_input( lookup )
    input = []
    case lookup
      when "corporations" then
        input << content_tag(:div, [content_tag(:label, 'Corporation:', :for => 'corporations'), text_field_with_auto_complete(:pilot, :corporation_name)], :class => 'corporations')
        input << hidden_field_tag(:layout, 'corporations')
      when "alliances" then
        input << content_tag(:div, [content_tag(:label, 'Alliance:', :for => 'alliances'), text_field_with_auto_complete(:alliance, :name)], :class => 'alliances')
        input << hidden_field_tag(:layout, 'alliances')
      when "battles" then
        input << content_tag(:div, [content_tag(:label, 'System Name:', :for => 'systems'), text_field_with_auto_complete(:solar_system, :solarSystemName)], :class => 'battles')
        input << hidden_field_tag(:layout, 'battles')
      else
        input << content_tag(:div, [content_tag(:label, 'Lookup:', :for => 'query'), text_field_tag(:query)], :class => 'general')
    end
    input.to_s 
  end
    
end
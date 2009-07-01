module ApplicationHelper
  def navigation_menu
    menu_items = []
    menu_items << add_navigation_tab('Add Killmail', new_kill_url)
    menu_items << add_navigation_tab('Overview', root_url)
    menu_items << add_navigation_tab('Battles', battle_url)
    menu_items << add_navigation_tab('Corporations', corporation_url)
    menu_items << add_navigation_tab('Alliances', alliance_url)
    menu_items << add_navigation_tab('Search', search_url)

    content_tag(:div, content_tag(:ul, menu_items), :id => 'navigation')
  end
  
  def add_navigation_tab( text, url )
    content_tag(:li, link_to(text, url))
  end
  
  def footer_copyright
    content_tag(:p, '&#169; 2008 ' + link_to('Goonfleet', 'http://www.goonfleet.com'))
  end
  
  def flash_notice
    if flash[:notice]
      notice = flash[:notice]
      flash.clear
      content_tag(:div, notice, :id => "notice")
    end
    if flash[:error]
      notice = flash[:error]
      flash.clear
      content_tag(:div, notice, :id => "errorExplanation")
    end
  end
  
  def html_error
    case params[:code]
      when '404' then
        summary = "File Not Found"
        description = "The request you have made cannot be found on this server."
      when '500' then
        summary = "Service Temporarily Unavailable"
        description = "The server is temporarily unable to service your request due to maintenance downtime or capacity problems. Please try again later."
      else
        summary = "Error Unknown"
        description = "How did you even trigger this error?"
    end

    [content_tag(:h2, "Error #{params[:code]}"), content_tag(:h4, summary), content_tag(:p, description)]
  end
  
  def auto_complete_stylesheet
    content_tag('style', <<-EOT, :type => Mime::CSS)
      div.auto_complete {
        width: 350px;
        background: #000;
      }
      div.auto_complete ul {
        border:1px solid #888;
        margin:0;
        padding:0;
        width:100%;
        list-style-type:none;
      }
      div.auto_complete ul li {
        color: #000
        margin:0;
        padding:3px;
      }
      div.auto_complete ul li.selected {
        background-color: #999;
      }
      div.auto_complete ul strong.highlight {
        color: #800; 
        margin:0;
        padding:0;
      }
    EOT
  end
end

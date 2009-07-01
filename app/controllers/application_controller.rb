class ApplicationController < ActionController::Base
  layout 'xhtml'

  #protect_from_forgery  :secret => 'e5b6b46a1f3d23a0030afcbafb86fe56ea1151ce'
  filter_parameter_logging :password
  around_filter :catch_errors
  helper :all
  
  def error
    render :action => 'error'
  end
  
  protected
    def self.protected_actions
      [ :edit, :update, :destroy ]
    end
  
  private
    def catch_errors
      begin
        yield
      
      rescue DRb::DRbConnError
        flash[:error] = "Search Index is down.  Contact an Administrator."
        redirect_to error_url(500)
        
      rescue ActionController::RoutingError
        redirect_to error_url(404)
        
      rescue ActiveRecord::RecordNotFound
        flash[:error] = "No records found for query: #{session[:query].inspect}."
        redirect_to search_url
      end
    end
end

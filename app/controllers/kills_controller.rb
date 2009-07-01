class KillsController < ApplicationController
  before_filter :load_kills_by_query, :only => [ :search ]
  before_filter :load_kill_by_id, :only => [ :show, :raw ]
  
  auto_complete_for :pilot, :corporation_name
  auto_complete_for :pilot, :name
  auto_complete_for :alliance, :name
  auto_complete_for :solar_system, :solarSystemName
  auto_complete_for :region, :regionName

  def parse_query
    query = []

    case params[:method]
      when 'route' then
        params[:field].nil? ? query << params[:query] : query << "#{params[:field]}:#{params[:query]}"
      when 'builder'then
        query << "alliances:#{params[:alliance][:name]}" unless params[:alliance].nil? or params[:alliance][:name].empty?
        query << "players:#{params[:pilot][:name]}" unless params[:pilot].nil? or params[:pilot][:name].nil? or params[:pilot][:name].empty?
        query << "corporations:#{params[:pilot][:corporation_name]}" unless params[:pilot].nil? or params[:pilot][:corporation_name].nil? or params[:pilot][:corporation_name].empty?
        query << "region:#{params[:region][:regionName]}" unless params[:region].nil? or params[:region][:regionName].empty?
        query << "solar_system:#{params[:solar_system][:solarSystemName]}" unless params[:solar_system].nil? or params[:solar_system][:solarSystemName].empty?
        
        unless params[:date].nil?
          min_time = DateTime.parse("#{params[:date][:min_date]} #{params[:date][:min_time]}")
          max_time = DateTime.parse("#{params[:date][:max_date]} #{params[:date][:max_time]}")
        
          unless min_time.eql? max_time
            max = Time.utc( max_time.year, max_time.month, max_time.day, max_time.hour, max_time.min ).to_i
            min = Time.utc( min_time.year, min_time.month, min_time.day, min_time.hour, min_time.min ).to_i
            query << "date:[#{min} #{max}]"
          end
        end
      else
        query << session[:query]
    end
    session[:query] = query.join(' AND ')
    return query.join(' AND ')
  end
  
  protected
    def load_kills_by_query(q = nil)
      return false if params[:method].nil?
      query = parse_query if q.nil?
      query ||= q
      
      sort = Ferret::Search::SortField.new(:date, :reverse => true)
      limit ||= params[:limit]
      @kills = Kill.find_with_ferret( query, :page => params[:page], :sort => sort, :per_page => limit)
      raise ActiveRecord::RecordNotFound if @kills.total_hits.eql? 0 
      @kills
    end
  
    def load_kill_by_id
      @kill = Kill.find_by_id( params[:id] ) or raise ActiveRecord::RecordNotFound
    end
    
  public
    def index
      params[:limit] = 15
      @gf_kills = load_kills_by_query('victors_details:*Goonswarm*')
      @gf_losses = load_kills_by_query('victim_details:*Goonswarm*')
      @kills = @gf_kills + @gf_losses
      
      respond_to do |format|
        format.html { render :action => 'overview' }
        format.xml  { render :xml => @kills.to_xml }
      end
    end
    
    def show
      respond_to do |format|
        format.html { render :action => 'show' }
        format.xml  { render :xml => @kill.to_xml }
      end
    end
    
    def search
      respond_to do |format|
        format.html do 
          if @kills.nil?
            render :action => 'builder'
          else
            unless params[:layout].nil?
              render :action => params[:layout]
            else
              render :action => 'search'
            end
          end
        end
        format.xml  { render :xml => @kills.to_xml }
      end
    end

    def new
      @kill = Kill.new
    end
    
    def create
      @kill = Kill.new( params[:kill] )

      if @kill.save
        flash[:notice] = 'Kill was successfully created.'

        respond_to do |format|
          format.html { redirect_to kill_path( @kill.id ) }
          format.xml  { head :created, :location => kill_path( @zone.id ) }
        end
      else
        flash[:error] = "The Killmail was malformed and wasn't saved."

        respond_to do |format|
          format.html { render :template => 'kills/new' }
          format.xml  { render :xml => @kill.errors.to_xml }
        end
      end
    end
end

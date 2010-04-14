class NewsController < ApplicationController

  # This action renders the homepage and lets you select a location.
  # If the users has a RepresentMe location cookie, they automatically get forwarded
  # to their saved location.
  def index
    if cookies["RepresentMe_location"]
      redirect_to :action => :view, :id => cookies["RepresentMe_location"] and return
    end
    if not flash[:error]
      flash[:notice] = "Currently only accepts Ottawa postal codes"
    end
    @title = "RepresentMe - Find out who's representing you and what they've been up to!"
  end

  # This action takes the user's form input, validates it, sets a cookie if needed and
  # redirects the user to the approppriate page.
  def find
    if params[:postal_code]
      @location = PostalCode.find_by_name(params[:postal_code])
      
      if @location
        if params['save']
          cookies["RepresentMe_location"] = {
            :value => @location.key,
            :expires => 1.year.from_now
          }
        end
        redirect_to :action => :view, :id => @location.key and return
      end
    end
    flash[:error] = "This postal code was not found in Ottawa"
    redirect_to :action => :index, :postal_code => params[:postal_code]
  end
  
  # This action clears the cookie and redirects the user back to the homepage.
  def change_location
    cookies.delete("RepresentMe_location")
    redirect_to :action => :index
  end

  # This action displays a location and its activity stream.
  def view
    @location = PostalCode.find_by_name(params[:id])
    build_activity_stream(@location)
    @title = "RepresentMe - Recent Activity for " + @location.name
  end
  
  # This action renders the activity stream for a given location as an RSS feed.
  def rss
    @location = PostalCode.find_by_key(params[:id])
    build_activity_stream(@location)
    @title = "RepresentMe - Recent Activity for " + @location.name
    render :layout => false
  end
  
  # This action renders the activity stream for a given location as an Atom feed.
  def atom
    @location = PostalCode.find_by_key(params[:id])
    build_activity_stream(@location)
    @title = "RepresentMe - Recent Activity for " + @location.name
    render :layout => false
  end
  
  private
  
  # This method finds the representatives for a given location and builds an activity stream
  # that shows the activities of those representatives.
  def build_activity_stream(location)
    find_representatives(@location)
    @activity_stream = ActivityStream.new()
    @activity_stream.add_entries(fetch_article_entries())
    @activity_stream.add_entries(fetch_vote_entries())
  end
  
  # This method takes a location and searches Freebase.com for the politicians which represent the
  # associated political districts.
  def find_representatives(location)
    # Load the MQL query from disk
    query = Freebase.parse_query(File.join(RAILS_ROOT, 'queries', 'find_representatives_by_political_district.mql').to_s)
    
    # Fill in the IDs of the political districts we're looking for.
    regions_ids =[]
    regions_ids << location.municipal_ward
    regions_ids << location.provincial_riding
    regions_ids << location.federal_riding
    query[0]["filter:id|="] = regions_ids
    
    # Send the query to Freebase.com via the read service API
    freebase_data = Freebase.read(query)
    
    @districts = {}
    @representatives = {}
    @representatives_by_district = {}
    
    # Parse the results of the query and create mappings between the respresntatives and the districts
    # that they represent.
    freebase_data.each { |district|
      @districts[district["id"]] = district
      if district["representatives"]
        role = ''
        if district["id"] == location.municipal_ward
          role = "City Councillor"
        elsif district["id"] == location.provincial_riding
          role = "Member of Provincial Parliament"
        elsif district["id"] == location.federal_riding
          role = "Member of Parliament"
        end
        district["representatives"]["office_holder"]["role"]  = role
        @representatives[district["representatives"]["office_holder"]["id"]] = district["representatives"]["office_holder"]
        @representatives_by_district[district["id"]] = district["representatives"]["office_holder"]
      end
    }
  end
  
  # Fetch relevant articles as a list of activity stream entries.
  def fetch_article_entries()
    entries = []
    
    # Fetch a list of news articles from the database that mention the given representatives.
    articles = NewsArticle.find_by_sql(["SELECT a.*, e.entity_id FROM news_articles a, article_entities e WHERE e.article_id = a.id AND e.entity_id IN (?) ORDER BY `date` DESC;", @representatives.keys])
    
    # Group representatives together if more than one is mentioned per article.
    entities_by_article = {}
    articles.each { |article|
       entities = entities_by_article[article.id.to_s]
       if not entities
          entities = []
          entities_by_article[article.id.to_s] = entities
       end
       entities << @representatives[article.entity_id]
    }
    
    # Package each article as an activity stream entry and return a list of entries.
    unique_articles = articles.uniq
    unique_articles.each { |article|
      article["representatives"] = entities_by_article[article.id.to_s].uniq
      entry = ActivityStream::Entry.new(article.date, article)
      entry.link_title = article.title
      entry.link_url = article.url
      # Generate the CSS class name based on the domain of the link.
      parts = article.url.to_s.split('/')[2].split('.')
      entry.link_class = parts[parts.length - 2] + "_" + parts[parts.length - 1]
      entries << entry
    }
    return entries
  end
  
  # Fetch relevant votes as a list of activity stream entries.
  def fetch_vote_entries()
    entries = []
    
    # Fetch a list of votes from the database that belong to the given representatives.
    votes = RepresentativeVote.find(:all, :conditions => ["representative_id = ?", @representatives_by_district[@location.federal_riding]["id"]])
    
    # Group votes together if more than one vote pertains to a single piece of legislation.
    vote_types_by_vote = {}
    votes.each { |vote|
       vote_types = vote_types_by_vote[vote.vote_id.to_s]
       if not vote_types
          vote_types = []
          vote_types_by_vote[vote.vote_id.to_s] = vote_types
       end
       vote_types << vote.vote_type
    }
    
    # Package each vote as an activity stream entry and return a list of entries.
    votes.each { |vote|
      vote["representative"] = @representatives_by_district[@location.federal_riding]
      entry = ActivityStream::Entry.new(vote.date, vote)
      entry.link_title = "Bill #{vote.name} - #{vote.title}"
      entry.link_url = "http://howdtheyvote.ca/vote.php?id=#{vote.vote_id}"
      entry.link_class = (vote.choice == 'Y' ? 'yes_vote' : 'no_vote')
      entries << entry
    }
    return entries
  end

end

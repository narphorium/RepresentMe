require 'set'

# This class is a container data structure that is used to organize a stream of heterogeneous events.
# Each event is represented as an Entry which has a date, a data object and a hyperlink.
# Activity stream entries can be accessed as a single, continuous list or they can be queried for a 
# specific date. In either case, the events are sorted in order of most recent to least recent.
class ActivityStream
  
  # This class is used to store discrete events within an activity stream. 
  class Entry
    
    # The date of the event
    attr_accessor :date
    
    # As object that contains data relevant to the event. 
    attr_accessor :object
    
    # The title of the hyperlink for this entry.
    attr_accessor :link_title
    
    # The URL of the hyperlink for this entry.
    attr_accessor :link_url
    
    # The CSS class of the hyperlink for this entry.
    attr_accessor :link_class
    
    # Default constructor takes a date and an object.
    def initialize(date, object)
      @date = date
      @object = object
    end
  end
  
  # Default constructor. Initializes an empty activity stream.
  def initialize()
    @entries = Set.new
    @entries_by_date = {}
  end
  
  # Given an array of new entries, add them to appropiate location in the activity stream
  # based on their date.
  def add_entries(new_entries)
    new_entries.each { |entry|
      @entries << entry
      date_key = entry.date.strftime("%Y-%m-%d")
      entry_set = @entries_by_date[date_key]
      if not entry_set
        entry_set = Set.new
        @entries_by_date[date_key] = entry_set
      end
      entry_set << entry
    }
  end
  
  # Get an array of activity stream entries; sorted from most recent to least recent.
  def entries()
    return @entries.to_a.sort { |a,b|
      a.date <=> b.date
    }
  end
  
  # Get an array of activity stream entries for the given date; sorted from most recent to least recent.
  def entries_by_date(date)
    return @entries_by_date[date].sort { |a,b|
      a.date <=> b.date
    }
  end
  
  # Get an array of dates contained in the current activity stream; sorted from most recent to least recent.
  def entry_dates()
    return @entries_by_date.keys.sort.reverse()
  end
  
end
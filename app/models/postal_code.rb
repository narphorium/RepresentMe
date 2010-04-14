
# This class is used to maintain the relationship between a postal code and the political districts
# that contain it. These values are pre-computed elsewhere and store in the dataebase. 
# Each postal code has foreign keys to the various political districts that contain it. These foreign
# keys are Freebase topic IDs and are used to to serach for additional data via the Freebase API.
class PostalCode < ActiveRecord::Base
  
  # Add a space to the middle of the postal code key to display it in its most common format.
  def name
    return key[0..2] + " " + key[3..5]
  end
  
  # Clean up various different postal code formats to find a database entry by its key.
  # Recognized formats are:
  #  * A1A2B2
  #  * A1A 2B2
  #  * A1A-2B2
  #  * A1A_2B2
  def self.find_by_name(query)
    query_key = query.strip

    query_key = query_key.gsub('_', '')
    query_key = query_key.gsub('-', '')
    query_key = query_key.gsub(' ', '')
    return self.find_by_key(query_key.upcase)
  end
  
end

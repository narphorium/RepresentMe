require 'httparty'
require 'json'

# This class is used to interact with the Freebase.com read service API.
# For more details see: http://www.freebase.com/docs/mql/ch04.html#mqlreadservice
class Freebase
  include HTTParty
  format :json
  base_uri 'http://www.freebase.com/api'

  # This method takes an object representing an MQL query, sends it to the read service API and
  # returns the results.
  # The query object is simply a combination of nested arrays and hashes.
  def self.read(q)
    puts 'Freebase Read: ' + q.to_json
    response = get('/service/mqlread?', :query => {:query => '{"query":' + q.to_json + '}'})
    return response['result']
  end
  
  # This helper method load an MQL query from disk.
  # This is useful to help keep the queries seperate from code.
  def self.parse_query(file)
    buffer = File.open(file,'r+').read
    query = JSON.parse(buffer)
    return query
  end
  
end
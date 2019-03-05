require 'httparty'

# https://www.pivotaltracker.com/services/v5/projects/1480690/stories?filter=owner:AR state:started
#

PROJECT_ID = ARGV[0].to_i
PROJECT_TOKETS = {
    # [PROJECT_ID] => [API_TOKEN]
}

class Pivotal
  include HTTParty
  headers 'X-TrackerToken' => PROJECT_TOKETS[PROJECT_ID]
  base_uri 'https://www.pivotaltracker.com/services/v5'

  def my_stories
    self.class.get("/projects/#{PROJECT_ID}/stories", query: { filter: 'owner:AR state:started,unstarted' })
  end

  def my_stories_formatted
    my_stories.parsed_response.map do |i|
      res = { title: i['name'], arg: i['id'] }
      if i['description']
        res[:subtitle] = i['description']
      end
      res
    end
  end
end

puts({ items: Pivotal.new.my_stories_formatted }.to_json)
# p Pivotal.new.my_stories.parsed_response


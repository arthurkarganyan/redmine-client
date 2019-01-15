require_relative '../env'

# https://easyredmine.docs.apiary.io/#reference/issues/issue/retrieve-issue

PROFESSIONAL_SERVICES_ID = 18
LIMIT = 100

REDMINE_USERNAME = ENV['REDMINE_USERNAME'] || fail("env REDMINE_USERNAME is not set")
REDMINE_PASSWORD = ENV['REDMINE_PASSWORD'] || fail("env REDMINE_PASSWORD is not set")
REDMINE_FULLNAME = ENV['REDMINE_FULLNAME'] || fail("env REDMINE_FULLNAME is not set")
REDMINE_URL = ENV['REDMINE_URL'] || fail("env REDMINE_URL is not set")

class Redmine
  include HTTParty
  base_uri REDMINE_URL
  basic_auth REDMINE_USERNAME, REDMINE_PASSWORD

  def projects
    self.class.get("/projects.xml")["projects"]
  end

  def issue(id)
    self.class.get("/issues/#{id}.xml", {})["issue"]
  end

  def issues
    offset = 0
    res = []
    5.times do
      query = { project_id: PROFESSIONAL_SERVICES_ID, limit: LIMIT, offset: offset }
      a = self.class.get("/issues.xml", query: query)["issues"]
      res += a
      return res if a.count < LIMIT
      offset += LIMIT
    end
  end

  def issues_filtered
    res = issues.reject do |issue|
      ["On Hold: Technical", "On Hold: Business", "In QA", "Passed QA"].include?(issue["status"]["name"])
    end
    res = res.select do |issue|
      !issue["assigned_to"] || issue["assigned_to"]["name"] == "Engineering" || issue["assigned_to"]["name"] == REDMINE_FULLNAME
    end
    res.sort_by do |issue|
      issue["priority"]["name"].split("").last.to_i
    end
  end
end

r = Redmine.new

# a = r.projects
i = r.issues_filtered
i.each do |issue|
  puts "#{issue["priority"]["name"]} #{issue["status"]["name"]} #{issue["subject"]} #{REDMINE_URL}/issues/#{issue["id"]}"
end
# binding.pry
# issue = r.issue(1464)
#
# puts ""
# puts "Subject:\t" + issue["subject"].yellow
# puts "Assigned to:\t" + issue["assigned_to"]["name"].green
# puts "Status:\t\t" + issue["status"]["name"].red
# puts ""
# puts issue["description"]

# binding.pry

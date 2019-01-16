require 'pry'
require 'httparty'
require 'tty-prompt'
require 'shellwords'
require 'colorize'

require_relative 'issue_filters/my_issues_filter'
require_relative 'issue_filters/take_new_issue_filter'
require_relative 'issue_filters/keyword_issues_filter'
require_relative 'issue'

# https://easyredmine.docs.apiary.io/#reference/issues/issue/retrieve-issue

LIMIT = 100

REDMINE_USERNAME = ENV['REDMINE_USERNAME'] || fail("env REDMINE_USERNAME is not set")
REDMINE_PASSWORD = ENV['REDMINE_PASSWORD'] || fail("env REDMINE_PASSWORD is not set")
REDMINE_FULLNAME = ENV['REDMINE_FULLNAME'] || fail("env REDMINE_FULLNAME is not set")
REDMINE_URL = ENV['REDMINE_URL'] || fail("env REDMINE_URL is not set")
DEFAULT_PROJECT_ID = ENV['DEFAULT_PROJECT_ID'] || fail("env DEFAULT_PROJECT_ID is not set")

class Redmine
  include HTTParty
  base_uri REDMINE_URL
  basic_auth REDMINE_USERNAME, REDMINE_PASSWORD

  def projects
    self.class.get("/projects.xml")["projects"]
  end

  def issue(id)
    Issue.new(self.class.get("/issues/#{id}.xml", {})["issue"])
  end

  def issues
    offset = 0
    res = []
    5.times do
      query = { project_id: DEFAULT_PROJECT_ID, limit: LIMIT, offset: offset }
      a = self.class.get("/issues.xml", query: query)["issues"]
      res += a
      return res if a.count < LIMIT
      offset += LIMIT
    end
  end

  def issues_objs
    issues.map do |issue_hash|
      Issue.new(issue_hash)
    end
  end

  def issues_sorted
    issues_objs.sort_by do |issue|
      issue.priority.split("").last.to_i
    end
  end
end

client = Redmine.new
index = ARGV.find_index("--no")

issues = client.issues_sorted

if index
  exclude_keywords = ARGV[index + 1].split(",")
  issues = KeywordIssuesFilter.new(issues, exclude_keywords).call
end

if ARGV[0] == "my"
  i = MyIssuesFilter.new(issues).call
  puts "Number of issues: #{i.count}"
  i.each do |issue|
    puts issue.formatted_short
  end
elsif ARGV[0] == "new"
  i = TakeNewIssueFilter.new(issues).call
  puts "Number of issues: #{i.count}"
  i.each do |issue|
    puts issue.formatted_short
  end
elsif ARGV[0].to_i.to_s == ARGV[0]
  issue = client.issue(ARGV[0])
  puts "\n#{issue.formatted}"
else
  fail "Argument is expected"
end


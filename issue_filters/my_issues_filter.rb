require_relative 'issues_filter'

class MyIssuesFilter < IssuesFilter
  def call
    issues.select do |issue|
      issue["assigned_to"] && issue["assigned_to"]["name"] == REDMINE_FULLNAME
    end
  end
end

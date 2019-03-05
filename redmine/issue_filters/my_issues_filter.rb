require_relative 'issues_filter'

class MyIssuesFilter < IssuesFilter
  def call
    issues.select do |issue|
      issue.assigned_to == REDMINE_FULLNAME
    end
  end
end

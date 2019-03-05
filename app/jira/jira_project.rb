class JiraProject < Project
  attr_reader :jira_project, :username, :include_statuses

  def initialize(username:, token:, url:, project_name:, include_statuses:)
    @username = username
    @client = JiraClient.new(username: username, token: token, url: url)
    @name = project_name
    @jira_project = @client.find_project(@name)
    @include_statuses = include_statuses
  end

  private def issues
    @issues ||= JIRA::Resource::Issue.jql(@client, jql)
  end

  def my_issues
    @my_issues ||= issues.select do |issue|
      issue.assignee && issue.assignee.emailAddress == username
    end.map do |issue|
      JiraIssue.new(jira_issue: issue, jira_url: @client.options[:site])
    end.sort_by(&:status)
  end

  def jql_statuses
    "(" + include_statuses.map do |st|
      "\"#{st}\""
    end.join(",") + ")"
  end

  def jql
    res = "project=\"#{@jira_project.key}\" and assignee=currentuser() and status in #{jql_statuses}"
    puts res
    res
  end
end

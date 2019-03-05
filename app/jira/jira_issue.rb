class JiraIssue < Issue
  def initialize(jira_issue:, jira_url:)
    @jira_issue = jira_issue
    @jira_url = jira_url
  end

  def url
    "#{@jira_url}/browse/#{@jira_issue.key}"
  end

  def priority
    @jira_issue.priority.name
  end

  def subject
    @jira_issue.summary
  end

  def status
    @jira_issue.status.name
  end
end

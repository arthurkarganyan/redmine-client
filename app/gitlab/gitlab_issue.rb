class GitLabIssue < Issue
  attr_reader :issue

  def initialize(issue)
    @issue = issue
  end

  def url
    issue.web_url
  end

  def priority
    "Medium"
  end

  def subject
    issue.title
  end

  def status
    issue.state
  end

  def description
    issue.description
  end
end

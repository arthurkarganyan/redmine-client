class RedmineIssue
  attr_reader :issue_hash

  def initialize(issue_hash)
    @issue_hash = issue_hash
  end

  def formatted
    res = []
    res << "Subject:\t" + subject.yellow
    res << "Assigned to:\t" + assigned_to.green
    res << "Status:\t\t" + status.red
    res << ""
    res << description
    res.join("\n")
  end

  def url
    "#{REDMINE_URL}/issues/#{id}"
  end

  def description
    issue_hash["description"]
  end

  def status
    issue_hash["status"]["name"]
  end

  def assigned_to
    return issue_hash["assigned_to"]["name"] if issue_hash["assigned_to"]
    "None"
    # issue_hash["assigned_to"]["name"]
  end

  def subject
    issue_hash["subject"]
  end

  def priority
    issue_hash["priority"]["name"]
  end

  def id
    issue_hash["id"]
  end
end

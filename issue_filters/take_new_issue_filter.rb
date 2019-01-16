require_relative 'issues_filter'

class TakeNewIssueFilter < IssuesFilter
  def call
    # res = issues.reject do |issue|
    #   ["On Hold: Technical", "On Hold: Business", "In QA", "Passed QA"].include?(issue["status"]["name"])
    # end
    res = issues.select do |issue|
      ["New"].include?(issue["status"]["name"])
    end
    res.select do |issue|
      !issue["assigned_to"] || issue["assigned_to"]["name"] == "Engineering"
    end
  end
end

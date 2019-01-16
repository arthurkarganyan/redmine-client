require_relative 'issues_filter'

class KeywordIssuesFilter < IssuesFilter
  attr_reader :keywords

  def initialize(issues, keywords)
    @issues = issues
    @keywords = keywords
  end

  def call
    issues.reject do |issue|
      keywords.any? do |keyword|
        issue.subject[keyword] || (issue.description && issue.description[keyword])
      end
    end
  end
end

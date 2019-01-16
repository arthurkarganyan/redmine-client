require_relative 'issues_filter'

class KeywordIssuesFilter < IssuesFilter
  attr_reader :keywords

  def initialize(issues, keywords)
    @issues = issues
    @keywords = keywords.map(&:downcase)
  end

  def call
    issues.reject do |issue|
      keywords.any? do |keyword|
        issue.subject.downcase[keyword]
      end
    end
  end
end

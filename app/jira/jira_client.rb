require 'rubygems'
require 'jira-ruby'

class JiraClient < JIRA::Client

  def initialize(username:, token:, url:)
    options = {
        username: username,
        password: token,
        context_path: '',
        site: url,
        # context_path: '',
        auth_type: :basic
    }

    super(options)

    # project.issues.each do |issue|
    #   puts "#{issue.id} - #{issue.summary}"
    # end
  end

  def projects
    self.Project.all
  end

  def project_names
    self.Project.all.map(&:name)
  end

  def find_project(project_name)
    projects.detect do |pr|
      pr.name == project_name
    end
  end

end

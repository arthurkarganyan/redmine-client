#!/usr/bin/env ruby

require 'pry'
require 'yaml'
require 'gitlab'
require "active_support/core_ext/hash"

require_relative 'app/abstract/project'
require_relative 'app/abstract/client'
require_relative 'app/abstract/issue'

require_relative 'app/gitlab/gitlab_client'
require_relative 'app/gitlab/gitlab_issue'
require_relative 'app/gitlab/gitlab_project'

require_relative 'app/jira/jira_client'
require_relative 'app/jira/jira_project'
require_relative 'app/jira/jira_issue'

config = YAML.load_file(".projects.yml").deep_symbolize_keys!

projects = config[:projects].map do |project_config|
  tracker = project_config.delete(:tracker)
  clazz = if tracker == 'jira'
            JiraProject
          elsif tracker == 'gitlab'
            GitLabProject
          else
            fail "no tracker found!"
          end

  clazz.new(project_config)
end.each(&:my_issues)

# project = projects[1]
projects.each do |project|
  project.my_issues.each do |issue|
    puts issue.formatted_short
  end
end



require 'rubygems'
require 'jira-ruby'

options = {
    :username => 'username',
    :password => 'pass1234',
    :site => 'http://mydomain.atlassian.net:443/',
    :context_path => '',
    :auth_type => :basic
}

client = JIRA::Client.new(options)

project = client.Project.find('SAMPLEPROJECT')

project.issues.each do |issue|
  puts "#{issue.id} - #{issue.summary}"
end
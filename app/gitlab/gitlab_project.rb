class GitLabProject < Project
  attr_reader :client, :project, :include_statuses

  def initialize(url:, token:, project_id:, include_statuses:)
    Gitlab.endpoint = url
    @client = Gitlab.client(private_token: token)
    @project = client.project(project_id)
    @include_statuses = include_statuses
  end

  # def projects
  # my_projects = client.user_projects(client.user.id)
  # my_projects.map do |project|
  #   puts "#{project.name}\t#{project.ssh_url_to_repo}"
  # end
  # end
  def my_issues
    @my_issues ||= begin
      client.issues(project.id).map do |i|
        GitLabIssue.new(i)
      end.select do |i|
        include_statuses.include?(i.status)
      end
    end
  end
end

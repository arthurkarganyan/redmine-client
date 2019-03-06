class GitLabClient < Client
  attr_reader :client

  def initialize(url:, token:)
    Gitlab.endpoint = url
    @client = Gitlab.client(private_token: token)
  end

  def projects
    my_projects = client.user_projects(client.user.id)
    my_projects.map do |project|
      puts "#{project.name}\t#{project.ssh_url_to_repo}"
    end
  end
end

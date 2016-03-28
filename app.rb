require "json"
require "sinatra"
require "tilt/erubis"
require "octokit"


github_login = "dl-leeroy"
github_password = "zyde3xo9ne1whoh1re8do7wu7he5ne"

Octokit.configure do |c|
  c.login = github_login
  c.password = github_password
end

get "/" do
  File.open("data.txt", "r") do |file|
    @contributors = JSON.parse(file.read)
  end

  erb :index
end

get "/process" do
  contributors = processContributors()

  contributors = JSON.fast_generate(contributors)

  File.open("data.txt", "w") { |file|
    file.write(contributors)
  }

  return contributors
end

## funcs

def processContributors
  contributors = []

  # members = [
  #   { :login => "dtrenz" },
  #   { :login => "btkelly" },
  #   { :login => "northofnormal" },
  # ]

  members = fetchMembers("detroit-labs")

  members.each do |user|
    events = Octokit.user_public_events(user[:login])

    events.map! { |event|
      {
        :type => event.type,
        :repo => event.repo,
      }
    }

    activity = tally(events)

    unless activity.empty?
      contributors.push(
        :user => user,
        :activity => activity,
      )
    end
  end

  return contributors
end

def fetchMembers(org)
  members = Octokit.org_members(org)

  members.map! { |user|
    {
      :login => user.login,
      :avatar_url => user.avatar_url,
      :html_url => user.html_url,
    }
  }

  return members
end

def tally(events)
  relevant_events = [
    # "CommitCommentEvent",
    "CreateEvent",
    # "DeleteEvent",
    # "DeploymentEvent",
    # "DeploymentStatusEvent",
    # "DownloadEvent",
    # "FollowEvent",
    # "ForkEvent",
    # "ForkApplyEvent",
    "GistEvent",
    # "GollumEvent",
    "IssueCommentEvent",
    "IssuesEvent",
    # "MemberEvent",
    # "MembershipEvent",
    "PageBuildEvent",
    "PublicEvent",
    "PullRequestEvent",
    "PullRequestReviewCommentEvent",
    "PushEvent",
    "ReleaseEvent",
    "RepositoryEvent",
    # "StatusEvent",
    # "TeamAddEvent",
    # "WatchEvent",
  ]

  tally = {}

  events.each do |event|
    event_type = event[:type]
    if relevant_events.include?(event_type)
      unless tally.key?(event_type)
        tally[event_type] = 0
      end

      tally[event_type] += 1
    end
  end

  tally = tally.sort.to_h

  return tally
end

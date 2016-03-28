require "json"
require "sinatra"
require "octokit"


github_login = "dl-leeroy"
github_password = "zyde3xo9ne1whoh1re8do7wu7he5ne"

Octokit.auto_paginate = true
Octokit.configure do |c|
  c.login = github_login
  c.password = github_password
end

not_found do
  status 404
end

get "/" do
  @descriptions = {
    "GistEvent" => "📄 Published <em>%d</em> public gist(s).",
    "IssueCommentEvent" => "📝 Posted <em>%d</em> issue comment(s).",
    "IssuesEvent" => "🗯 Created <em>%d</em> issue(s).",
    "PageBuildEvent" => "🌎 Built a github pages site <em>%d</em> time(s).",
    "PublicEvent" => "🔓 Made <em>%d</em> private repo(s) public.",
    "PullRequestEvent" => "📤 Submitted <em>%d</em> pull request(s).",
    "PullRequestReviewCommentEvent" => "💭 Commented <em>%d</em> time(s) on a pull request.",
    "PushEvent" => "🚀 Pushed to a public repo <em>%d</em> time(s).",
    "ReleaseEvent" => "🚢 Published <em>%d</em> release(s).",
    "RepositoryEvent" => "📁 Created <em>%d</em> public repo(s).",
  }

  File.open("data.txt", "r") do |file|
    @contributors = JSON.parse(file.read)
  end

  @updated = File.mtime("data.txt")

  erb :index
end

get "/refresh-data" do
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

  members = fetchMembers("detroit-labs")

  members.each do |user|
    events = Octokit.user_public_events(user[:login], { :per_page => 100 })

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
  blacklist = [ "houndci-bot" ]

  members = Octokit.team_members(61888, { :per_page => 100 })

  members.select! { |member| !blacklist.include?(member.login) }

  members.map! { |user|
    {
      :login => user.login,
      :avatar_url => user.avatar_url,
      :html_url => user.html_url,
    }
  }

  members.sort_by! { |member| member[:login].downcase }

  return members
end

def tally(events)
  relevant_events = [
    # "CommitCommentEvent",
    # "CreateEvent",
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

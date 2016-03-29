require "json"

# gems
require "dotenv"
require "redis"
require "sinatra"
require "tilt/erb"

Dotenv.load

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

  redis = Redis.new

  contributorsJSON = redis.get("contributors")
  last_updated_string = redis.get("last_updated")

  unless contributorsJSON.nil?
    @contributors = JSON.parse(contributorsJSON)
    @updated = DateTime.parse(last_updated_string)
  end

  erb :index
end

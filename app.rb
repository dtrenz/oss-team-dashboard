require "json"

# gems
require "sinatra"

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

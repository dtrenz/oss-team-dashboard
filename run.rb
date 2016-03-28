#!/usr/bin/ruby

require "net/http"
require "json"

require "rubygems"
require "bundler/setup"
# Bundler.require(:default)
# require "octokit"


Octokit.configure do |c|
  c.login = 'dl-leeroy'
  c.password = 'zyde3xo9ne1whoh1re8do7wu7he5ne!'
end

puts Octokit.org_members('detroit-labs')


## funcs

def fetchMembers(org)
  members = []

  uri = URI("https://api.github.com/orgs/#{org}/members")

  res = Net::HTTP.get_response(uri)

  if res.is_a?(Net::HTTPSuccess)
    results = JSON.parse(res.body)

    results.each do |result|
      members = results.map { |member| member["login"] }
    end
  else
    puts "ERROR: #{res.body}"
  end

  return members
end

def fetchEvents(username)
  events = nil

  uri = URI("https://api.github.com/users/#{username}/events/public")

  res = Net::HTTP.get_response(uri)

  if res.is_a?(Net::HTTPSuccess)
    results = JSON.parse(res.body)

    results.each do |result|
      events = results.map { |event| event["type"] }
    end
  else
    puts "ERROR: #{res.body}"
  end

  return events
end

def tally(events)
  scoring = {
    :CreateEvent => 1,
    :GistEvent => 1,
    :PullRequestEvent => 10,
    :ReleasePushEvent => 20,
    :PublicEvent => 50,
  }

  tally = { :score => 0 }

  scoring.each do |key, val|
    tally[key] = 0
  end

  events.select! { |event| scoring.key?(event) }

  events.each do |event|
    event_key = scoring[event][:key]
    event_value = scoring[event][:value]

    tally[event_key] += 1
    tally[:score] += event_value
  end

  return tally  #.select! { |key, val| val > 0 || key == :score }
end


####

org = "detroit-labs"
rankings = {}

# members = fetchMembers(org)

# unless members.empty?
#   members.each do |username|
#     events = fetchEvents(username)
#     rankings[username] = tally(events)
#   end
# end

puts rankings

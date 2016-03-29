# OSS Team Dashboard
Simple web dashboard for highlighting open source activity &amp; contributions made 
by people in your GitHub organization, or on a specific team.

## Local Setup
To setup the project to run locally during development, create a file named `.env` at 
the root of the project directory, and populate the following `ENV` vars:

```ruby
GITHUB_ACCESS_TOKEN="q1w2e3r4t5y6u7i8o9p0a1s2d3f4g5h6j7k8l9z0"
GITHUB_TEAM_ID=12345
REDIS_URL="redis://u:p@$$w0rd@some-redis-host.com:13649"
```

## Running Locally
To run the web app locally:

`$ ruby app.rb`

To run the data refresh script that gathers GitHub activity stats:

`$ ./bin/refresh-data`

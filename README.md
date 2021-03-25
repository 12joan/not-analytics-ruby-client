# not Analytics Client

A client for [not Analytics](https://github.com/12joan/not-analytics).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'not-analytics-client', github: '12joan/not-analytics-client', branch: 'main'
```

And then execute:

    $ bundle install

## Usage

Instantiate a new Hit object for a given app ID.

```ruby
hit = NotAnalyticsClient::Hit.new(
  app_id,
  event: '/some/path', # Optional
  key: app_key, # Optional
)
```

Send the Hit to a not Analytics server.

```ruby
hit.post!(not_analytics_url: 'https://hit.example.com/')
# => #<Net::HTTPOK 200 OK readbody=true>
```

Or output the JSON payload.

```ruby
hit.payload
# => "{\"hit\":{\"app_id\":"...
```

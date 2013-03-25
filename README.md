# sunspot-queue [![Build Status](https://secure.travis-ci.org/gaffneyc/sunspot-queue.png?branch=master)](http://travis-ci.org/gaffneyc/sunspot-queue)

Background search indexing using existing worker systems.

## Install

```console
$ gem install sunspot-queue
```

## Usage with Rails and Resque

In your Gemfile

```ruby
gem "sunspot-queue"
gem "resque"
```

In config/initializers/sunspot.rb

```ruby
require "sunspot/queue/resque"
backend = Sunspot::Queue::Resque::Backend.new
Sunspot.session = Sunspot::Queue::SessionProxy.new(Sunspot.session, backend)
```

Start Resque

```console
$ QUEUE=sunspot rake resque:work
```

## Usage with Rails and Sidekiq

In your Gemfile

```ruby
gem "sunspot-queue"
gem "sidekiq"
```

In config/initializers/sunspot.rb

```ruby
require "sunspot/queue/sidekiq"
backend = Sunspot::Queue::Sidekiq::Backend.new
Sunspot.session = Sunspot::Queue::SessionProxy.new(Sunspot.session, backend)
```

Start Sidekiq

```console
$ sidekiq -q sunspot
```

## Usage with Rails and Delayed::Job 

In your Gemfile

```ruby
gem "sunspot-queue"
gem "delayed_job"
gem "delayed_job_active_record"     # or choose another backend
```

In config/initializers/sunspot.rb

```ruby
require "sunspot/queue/delayed_job"
backend = Sunspot::Queue::DelayedJob::Backend.new
Sunspot.session = Sunspot::Queue::SessionProxy.new(Sunspot.session, backend)
```

Start Delayed::Job

```console
$ rake jobs:work 
```

## Configuring Sunspot Queue

In config/initializers/sunspot.rb

```ruby
Sunspot::Queue.configure do |config|
  # Override default job classes
  config.index_job   = CustomIndexJob
  config.removal_job = CustomRemovalJob
end
```

## Configuring Auto Commit

The sunspot-queue jobs update the Solr index but those changes don't appear in
search results until Solr commits those changes. Solr supports automatically
commiting changes based on either the number of changes and / or time between
commits.

Add (or uncomment) the following in solrconfig.xml

```xml
<autoCommit>
  <maxDocs>10000</maxDocs>
  <maxTime>30000</maxTime>
</autoCommit>
```

See [Solr's documentation](http://wiki.apache.org/solr/SolrConfigXml#Update_Handler_Section) for more information.

## Note on Patches/Pull Requests

* Fork the project.
* Add tests to show the problem or test your feature
* Make your feature addition or bug fix.
* Send me a pull request. Bonus points for topic branches.

Please don't make changes to the Rakefile, version, or history.

## Development

```console
$ gem install bundler
$ bundle
$ guard
```

## Copyright

See LICENSE for details.

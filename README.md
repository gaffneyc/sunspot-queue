# sunspot-queue [![Build Status](https://secure.travis-ci.org/gaffneyc/sunspot-queue.png?branch=master)](http://travis-ci.org/gaffneyc/sunspot-queue)

Background search indexing using existing worker systems.

## Install

    $ gem install sunspot-queue

## Usage with Rails and Resque

In your Gemfile

    gem "sunspot-queue"
    gem "resque"

In config/initializers/sunspot.rb

    require "sunspot/queue/resque"
    backend = Sunspot::Queue::Resque::Backend.new
    Sunspot.session = Sunspot::Queue::SessionProxy.new(Sunspot.session, backend)

Start Resque

    $ QUEUE=sunspot rake resque:work

## Usage with Rails and Sidekiq

In your Gemfile

    gem "sunspot-queue"
    gem "sidekiq"

In config/initializers/sunspot.rb

    require "sunspot/queue/sidekiq"
    backend = Sunspot::Queue::Sidekiq::Backend.new
    Sunspot.session = Sunspot::Queue::SessionProxy.new(Sunspot.session, backend)

Start Sidekiq

    $ sidekiq -q sunspot

## Configuring Auto Commit

The sunspot-queue jobs update the Solr index but those changes don't appear in
search results until Solr commits those changes. Solr supports automatically
commiting changes based on either the number of changes and / or time between
commits.

Add (or uncomment) the following in solrconfig.xml

```
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

    $ gem install bundler (if you don't have it)
    $ bundle install
    $ guard

## Copyright

See LICENSE for details.

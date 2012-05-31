# sunspot-queue

Background search indexing using existing worker systems.

## Install

    $ gem install sunspot-queue

## Usage with Rails (or without)

In your Gemfile

    gem "sunspot-queue"
    gem "resque"

In config/initializers/sunspot.rb

    Sunspot.session = Sunspot::Queue::SessionProxy.new(Sunspot.session)

Start Resque

    $ QUEUE=sunspot rake resque:work

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

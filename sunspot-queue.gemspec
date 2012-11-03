require File.expand_path("../lib/sunspot/queue/version", __FILE__)

# encoding: UTF-8
Gem::Specification.new do |s|
  s.name               = "sunspot-queue"
  s.homepage           = "https://github.com/gaffneyc/sunspot-queue"
  s.summary            = "Background search indexing using existing worker systems."
  s.require_path       = "lib"
  s.authors            = ["Chris Gaffney"]
  s.email              = ["gaffneyc@gmail.com"]
  s.version            = Sunspot::Queue::VERSION
  s.platform           = Gem::Platform::RUBY
  s.files              = Dir.glob("{lib,spec}/**/*") + %w[LICENSE README.md History.md]

  s.add_dependency "sunspot_rails",            ">= 1.3.0"

  s.add_runtime_dependency "resque"
  s.add_runtime_dependency "sidekiq"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec",        "~> 2.11.0"
  s.add_development_dependency "resque_spec"
  s.add_development_dependency "sunspot_solr"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "activerecord"

  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-bundler"
end

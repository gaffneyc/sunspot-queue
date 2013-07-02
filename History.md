# Sunspot Queue Changelog

## 0.11.2
* Fix an issue serializing to Sidekiq with Rails 4

## 0.11.1
* Allow without_proxy to work with SessionProxy subclasses
* Added missing requires in sidekiq jobs

## 0.11.0
* Delayed Job support

## 0.10.0
* Sidekiq support
* SessionProxy now takes a backend as a second required option
* Sunspot::Queue::Resque::Backend is the backend for Resque
* Sunspot::Queue::Sidekiq::Backend is the backend for Sidekiq

## 0.9.1
* Jobs no longer auto commit the solr index. Commits should be done by another process or
  Solr should be configured handle commits automatically (autoCommit config option).

## 0.9.0
* Initial Release

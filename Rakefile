# encoding: utf-8
require "bundler/setup"
require "rspec/core/rake_task"

# Add bundler gem building helpers
Bundler::GemHelper.install_tasks

desc "Run the specs"
RSpec::Core::RakeTask.new do |r|
  r.verbose = false
end

task :default => :spec

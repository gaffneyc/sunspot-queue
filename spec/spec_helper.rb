require "sunspot/queue"
require "sunspot/queue/helpers"

require "socket"
require "active_record"
require "sunspot"
require "sunspot/rails"
require "sunspot/solr/server"
require "resque_spec"

# Neither is required when loading sunspot/queue
require "sunspot/queue/resque"
require "sunspot/queue/sidekiq"
require "sunspot/queue/delayed_job"

# Sidekiq
require "sidekiq"
require "sidekiq/testing"

# Configure ActiveRecord and Sunspot to work with ActiveRecord
ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)

ActiveRecord::Schema.define do
  create_table :people, :force => true do |t|
    t.string :name
  end
end

# Pulled from the sunspot_rails Rails 3 railtie
Sunspot::Adapters::InstanceAdapter.register(Sunspot::Rails::Adapters::ActiveRecordInstanceAdapter, ActiveRecord::Base)
Sunspot::Adapters::DataAccessor.register(Sunspot::Rails::Adapters::ActiveRecordDataAccessor, ActiveRecord::Base)

class Person < ActiveRecord::Base
  include Sunspot::Rails::Searchable

  searchable do
    text :name
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.order = "random"

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[File.expand_path("../support/*.rb", __FILE__)].each { |f| require(f) }

  config.include(Sunspot::Queue::Helpers)
  config.include(
    Module.new do
      def commit
        without_proxy { Sunspot.commit }
      end
    end
  )

  # Original sunspot session not wrapped in our proxy object
  session = Sunspot.session

  # Clean up data between tests and reset the session
  config.before(:each) do
    Sunspot.session = session
    session.remove_all!
  end

  config.before(:each, :backend => :resque) do
    ResqueSpec.reset!

    backend = Sunspot::Queue::Resque::Backend.new
    Sunspot.session = Sunspot::Queue::SessionProxy.new(session, backend)
  end

  config.before(:each, :backend => :sidekiq) do
    Sidekiq::Worker.clear_all

    require "sunspot/queue/sidekiq"
    backend = Sunspot::Queue::Sidekiq::Backend.new
    Sunspot.session = Sunspot::Queue::SessionProxy.new(session, backend)
  end

  config.before(:each, :backend => :delayed_job) do
    Delayed::Worker.delay_jobs = false 

    require "sunspot/queue/delayed_job"
    backend = Sunspot::Queue::DelayedJob::Backend.new
    Sunspot.session = Sunspot::Queue::SessionProxy.new(session, backend)
  end

  config.before(:each, :backend => :inline) do
    backend = Sunspot::Queue::Inline::Backend.new
    Sunspot.session = Sunspot::Queue::SessionProxy.new(session, backend)
  end

  # Configure Solr and run a server in the background for the duration of the
  # tests.
  config.before(:suite) do
    solr_pid = fork do
      STDERR.reopen("/dev/null")
      STDOUT.reopen("/dev/null")

      server = Sunspot::Solr::Server.new
      server.run
    end

    at_exit { Process.kill("TERM", solr_pid) }

    # Wait up to 30 seconds for Solr to boot
    60.times do
      begin
        TCPSocket.new("localhost", 8983)
        break
      rescue
        sleep 0.5
      end
    end
  end
end

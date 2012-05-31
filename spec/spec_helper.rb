require "sunspot/queue"

require "socket"
require "active_record"
require "sunspot"
require "sunspot/rails"
require "sunspot/solr/server"
require "resque_spec"

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
  config.filter_run :focus

  # Original sunspot session not wrapped in our proxy object
  session = Sunspot.session

  config.before(:each) do
    session.remove_all!
    ResqueSpec.reset!

    Sunspot.session = Sunspot::Queue::SessionProxy.new(session)
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

    # Wait for up to 5 seconds for Solr to boot
    10.times do
      begin
        TCPSocket.new("localhost", 8983)
        break
      rescue
        sleep 0.5
      end
    end
  end
end

require "spec_helper"

describe "Sidekiq Integration", :backend => :sidekiq do
  let(:index_job)   { Sunspot::Queue::Sidekiq::IndexJob }
  let(:removal_job) { Sunspot::Queue::Sidekiq::RemovalJob }

  #
  it "queues indexing on creation and update" do
    jimmy = Person.create(:name => "Jimmy Olson")

    index_job.jobs.size.should == 1
    index_job.perform_work
    commit

    Person.search { fulltext "Olson" }.hits.size.should == 1

    jimmy.update_attribute(:name, "James Bartholomew Olsen")
    index_job.jobs.size.should == 1
    index_job.perform_work
    commit

    Person.search { fulltext "Bartholomew" }.hits.size.should == 1
  end

  it "queues removal on destroy" do
    pinky =
      without_proxy do
        Person.create(:name => "Pinky the Whiz Kid")
      end
    commit

    Person.search.hits.size.should == 1

    pinky.destroy
    removal_job.jobs.size.should == 1
    removal_job.perform_work
    commit

    Person.search.hits.size.should == 0
  end
end

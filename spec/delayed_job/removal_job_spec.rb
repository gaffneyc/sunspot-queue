require "spec_helper"
require "sunspot/queue/delayed_job"
require "sunspot/queue/helpers"

describe Sunspot::Queue::DelayedJob::RemovalJob do
  it "removes a job from the search index" do
    person =
      without_proxy do
        Person.create(:name => "The Albino")
      end
    commit

    Person.search.hits.size.should == 1

    job = Sunspot::Queue::DelayedJob::RemovalJob.new(Person, person.id) 
    expect do
      job.perform
      commit
    end.to change { Person.search.hits.size }.by(-1)
  end
end

require "spec_helper"
require "sunspot/queue/resque"
require "sunspot/queue/helpers"

describe Sunspot::Queue::Resque::RemovalJob do
  let(:job) { Sunspot::Queue::Resque::RemovalJob }

  it "is linked to Sunspot::Queue::IndexJob for backwards compatibility" do
    ::Sunspot::Queue::RemovalJob.should == ::Sunspot::Queue::Resque::RemovalJob
  end

  it "removes a job from the search index" do
    person =
      without_proxy do
        Person.create(:name => "The Albino")
      end
    commit

    Person.search.hits.size.should == 1

    expect do
      job.perform(Person, person.id)
      commit
    end.to change { Person.search.hits.size }.by(-1)
  end
end

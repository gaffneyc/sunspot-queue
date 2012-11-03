require "spec_helper"

describe Sunspot::Queue::Sidekiq::RemovalJob do
  let(:job) { Sunspot::Queue::Sidekiq::RemovalJob.new }

  it "removes a job from the search index" do
    person = Person.create(:name => "James 'Bucky' Barnes")
    commit

    Person.search.hits.size.should == 1

    expect do
      job.perform(Person, person.id)
      commit
    end.to change { Person.search.hits.size }.by(-1)
  end
end

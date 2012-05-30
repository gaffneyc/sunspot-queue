require "spec_helper"
require "sunspot/queue/helpers"

describe Sunspot::Queue::IndexJob do
  include Sunspot::Queue::Helpers

  it "removes a job from the search index" do
    person = 
      without_proxy do
        Person.create(:name => "The Albino")
      end

    Person.search.hits.size.should == 1

    expect do
      Sunspot::Queue::RemovalJob.perform(Person, person.id)
    end.to change { Person.search.hits.size }.by(-1)
  end
end

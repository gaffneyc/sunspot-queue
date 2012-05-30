require "spec_helper"
require "sunspot/queue/helpers"

describe "Queued Indexing" do
  include Sunspot::Queue::Helpers

  # Given an active record model
  # When I save the model
  # Then the record should not be in solr
  #
  # When resque jobs are run
  # Then the record should be in solr
  it "queues indexing of ActiveRecord models using resque" do
    person = Person.create(:name => "Inigo Montoya")
    Person.search.results.should be_empty

    expect do
      ResqueSpec.perform_all(:solr)
    end.to change { Person.search.hits.size }.by(1)

    results = Person.search { fulltext "Montoya" }.results
    results.first.should == person
  end

  # Given an active record model that is in Solr
  # When I destroy the model
  # Then the record should be in solr
  #
  # When resque jobs are run
  # Then the record should not be in solr
  it "queues removal of ActiveRecord models using Resque" do
    person = Person.create(:name => "Fezzik")
    ResqueSpec.perform_all(:solr)
    Person.search.hits.size.should == 1

    expect do
      person.destroy
    end.to_not change { Person.search.hits.size }

    expect do
      ResqueSpec.perform_all(:solr)
    end.to change { Person.search.hits.size }.by(-1)
  end
end

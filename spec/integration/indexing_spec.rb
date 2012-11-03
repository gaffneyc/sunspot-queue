require "spec_helper"

describe "Queued Indexing", :backend => :resque do
  # Given an active record model
  # When I save the model
  # Then the record should not be in solr
  # And a job should be enqueued in resque
  #
  # When resque jobs are run
  # And the sunspot queue has been committed
  # Then the record should be in solr
  it "queues indexing of ActiveRecord models using resque" do
    person = Person.create(:name => "Inigo Montoya")
    Person.search.results.should be_empty

    ResqueSpec.queue_by_name(:sunspot).size.should == 1

    expect do
      ResqueSpec.perform_all(:sunspot)
      commit
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
    person =
      without_proxy do
        Person.create(:name => "Fezzik").tap do
          commit
        end
      end

    Person.search.hits.size.should == 1

    expect do
      person.destroy
    end.to_not change { Person.search.hits.size }

    expect do
      ResqueSpec.perform_all(:sunspot)
      commit
    end.to change { Person.search.hits.size }.by(-1)
  end
end

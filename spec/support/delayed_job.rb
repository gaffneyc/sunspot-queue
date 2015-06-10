require "delayed_job"

# Fake Delayed::Job persistence backend.
# TODO: This isn't valid and the tests are probably not valid
class Delayed::Job
end

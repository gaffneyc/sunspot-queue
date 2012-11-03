module Sidekiq
    module Worker
    module ClassMethods
      def perform_work
        if job = jobs.pop
          self.new.perform(*Sidekiq.load_json(Sidekiq.dump_json(job["args"])))
        end

        true
      end

      def perform_all_the_work
        while jobs.any?
          perform_work
        end
      end
    end
  end
end

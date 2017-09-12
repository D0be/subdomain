require 'subdomain'

class SubdomainWorker
    include Sidekiq::Worker

    def perform(id)
        return if cancelled?
        task = Scan.find(id)
        domain = Domain.find_by(dname:task.target)
        task.running!
        options = {}
        options[:thread_num] = SubdomainBrute.configuration.thread_num
        options[:max_level] = SubdomainBrute.configuration.max_level
        scan = SubdomainBrute::Brute.new(task.target, options)
        scan.run
        scan.get_all_domains do |result|
            domain.sub_domains.create(result)
        end
        
        task.finished!
    end
    
    def cancelled?
        Sidekiq.redis {|c| c.exists("cancelled-#{jid}") }
    end

    def self.cancel!(jid)
        Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
    end
    
end

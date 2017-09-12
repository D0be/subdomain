require "ipaddr"
require "resolv"
module SubdomainBrute

	class Brute
		def initialize(root_domain, options)
			@root_domain = root_domain
			@options = options
			@options[:thread_num] ||= 50
			@options[:sub_names] = SubdomainBrute::get_subnames
			@options[:next_names] = SubdomainBrute::get_nextnames
			@options[:ns] ||= get_root_domain_ns
			@options[:max_level] ||= 3
			@init_level = 2
			@current_level = 2
			@domains_count = 0
			@ret = {}
			get_root_domain_ip
		end

		def get_root_domain_ns
			ns = []
			dns = Resolv::DNS.new
			dns.each_resource(@root_domain, Resolv::DNS::Resource::IN::NS) do |nameserver|
				ns += get_ip_by_name(nameserver.name)
			end
			ns += SubdomainBrute::get_ns
			ns
		end

		def get_root_domain_ip
			@ret[1] = []
			get_ip_by_name(@root_domain).each do |ip|
				@ret[1] << {sname: @root_domain, sip: ip}
			end
			@ret[1] << {sname: @root_domain, sip: "unknown host"} if @ret[1].empty?
		end

		def get_ip_by_name(name, ns = [])
			ip = []
			if ns.empty?
				dns = Resolv::DNS.new
			else
				dns = Resolv::DNS.new(:nameserver => ns)
			end
			error_count = 0
			begin
				dns.each_address(name) do |addr|
					ip << addr.to_s
				end
			rescue
				error_count += 1
				sleep(1)
				retry if error_count <= 5
			end
			ip
		end

		def run
			queue = Queue.new
			threads = []
			mutex = Mutex.new
			@init_level.upto(@options[:max_level]) do |level|
				@current_level = level
				exist_domains = []
				@ret[level] = []
				names = []

				@ret[level - 1].each do |domain|
					next if exist_domains.include?(domain[:sname])
					if level == 2
						names = @options[:sub_names]
					else
						names = @options[:next_names]
					end
					names.each do |name|
						queue << "#{name}.#{domain[:sname]}"
					end
					puts queue.size
				end
				next if queue.empty?
				@options[:thread_num].times do |i|
					threads << Thread.new do
						Thread.current.abort_on_exception = true
						until queue.empty?
							name = queue.pop
							#puts name
							get_ip_by_name(name, @options[:ns]).each do |ip|
								next if ip == "0.0.0.0"
								mutex.lock
								if @ret[level].select { |domain| domain[:sip] ==ip }.size < 10
									@ret[level] << {sname: name, sip: ip}
									puts "[+] #{name} => #{ip}"
								end
								mutex.unlock
							end
						end
					end
				end

				threads.each { |t| t.join }
				puts "[!]OVER"
			end

		end

		def get_domains_count
			@init_level.upto(@options[:max_level]) do |level|
				@ret[level].each do |domain|
					@domains_count += 1
				end
			end
			@domains_count
		end

        def get_all_domains
            @init_level.upto(@options[:max_level]) do |level|
                yield(@ret[level]) if block_given?
			end
        end
        
	end

	def self.get_subnames
		sub_names = []
		ns_file = SubdomainBrute.configuration.subdomainfile
		File.read(ns_file).split("\n").each do |line|
			line.strip!
			if not line.nil? and not line == ""
				sub_names << line
			end
		end
		sub_names
	end

	def self.get_ns
		ns = []
		ns_file = SubdomainBrute.configuration.nsfile
		File.read(ns_file).split("\n").each do |line|
			line.strip!
			begin
				ns << IPAddr.new(line).to_s
			rescue
			end
		end
		ns
	end

	def self.get_nextnames
		nextnames = []
		ns_file = SubdomainBrute.configuration.nextdomainfile
		File.read(ns_file).split("\n").each do |line|
			line.strip!
			if not line.nil? and not line == ""
				nextnames << line
			end
		end
		nextnames
	end
end

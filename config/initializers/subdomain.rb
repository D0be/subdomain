require 'yaml'
module SubdomainBrute
	class << self
		attr_accessor :configuration
	end
	def self.configure
		self.configuration ||= Configuration.new
		yield(configuration)
	end

	class Configuration
		attr_accessor :thread_num, :max_level, :nsfile, :subdomainfile, :nextdomainfile 
	end

	config_yml = YAML.load_file(File.expand_path('../config.yml', File.dirname(__FILE__)))
	puts config_yml
	SubdomainBrute.configure do |config|
		config.thread_num = config_yml['thread_num']
		config.max_level = config_yml['max_level']
		config.nsfile = File.expand_path(config_yml['nsfile'], File.dirname(__FILE__))
		config.subdomainfile = File.expand_path(config_yml['subdomainfile'], File.dirname(__FILE__))
		config.nextdomainfile = File.expand_path(config_yml['nextdomainfile'], File.dirname(__FILE__))
	end
end
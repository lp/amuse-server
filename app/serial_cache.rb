class SerialCache
	require 'yaml'
	require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers','path')
	require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers','crypt')
	
	CACHE_ROOT = File.join( File.dirname( File.expand_path(__FILE__)), '..','data','cache')
	
	unless File.exist?( File.join(CACHE_ROOT,'empty.cache'))
		File.open( File.join(CACHE_ROOT,'empty.cache'),'w') do |file|
			file.puts( Crypt.encrypt( YAML::dump( [{}])))
		end
	end
	
	def self.authors(dataset)
		File.open( File.join(CACHE_ROOT,'authors.cache'),'w') do |file|
			file.puts( Crypt.encrypt( YAML::dump( dataset.map)))
		end
	end
	
	def self.dashboard(dataset)
		last_id = dataset.order(:id).last[:id]; first_id = last_id - 10; first_id = 0 if first_id < 0
		File.open( File.join(CACHE_ROOT,'dashboard.cache'),'w') do |file|
			file.puts( Crypt.encrypt( YAML::dump( dataset.filter(:id => first_id..last_id).map )))
		end
	end
	
	def self.messages(dataset)
		message_threads = dataset.map
		cache_path = File.join(CACHE_ROOT,"projects/#{message_threads[0][:project_id].to_s}/#{message_threads[0][:thread_id].to_s}.cache")
		Path.make(Path.dir(cache_path))
		File.open(cache_path,'w') { |file| file.puts( Crypt.encrypt( YAML::dump( message_threads ))) }
	end
	
	def self.threads(dataset)
		project_threads = dataset.map
		cache_path = File.join(CACHE_ROOT,"projects/#{project_threads[0][:project_id].to_s}.cache")
		Path.make(Path.dir(cache_path))
		File.open(cache_path,'w') { |file| file.puts( Crypt.encrypt( YAML::dump( project_threads ))) }
	end
	
	def self.projects(dataset)
		File.open( File.join(CACHE_ROOT,'projects.cache'),'w') do |file|
			file.puts( Crypt.encrypt( YAML::dump( dataset.map)))
		end
	end
	
end
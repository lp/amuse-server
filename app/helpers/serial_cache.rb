class SerialCache
	require 'yaml'
	require 'app/helpers/path'
	require 'app/helpers/crypt'
	
	CACHE_ROOT = 'app/data/cache'
	
	def self.authors(dataset)
		File.open(Path.catname(CACHE_ROOT,'authors.cache'),'w') do |file|
			file.puts( Crypt.encrypt( YAML::dump( dataset.map)))
		end
	end
	
	def self.dashboard(dataset)
		last_id = dataset.last.map(:id); first_id = last_id - 10; first_id = 0 if first_id < 0
		File.open(Path.catname(CACHE_ROOT,'dashboard.cache'),'w') do |file|
			file.puts( Crypt.encrypt( YAML::dump( dataset.filter(:id => first_id..last_id).map )))
		end
	end
	
	def self.messages(dataset)
		message_threads = dataset.map
		cache_path = Path.catname(CACHE_ROOT,"projects/#{message_threads[0][:project_id].to_s}/#{message_threads[0][:thread_id].to_s}.cache")
		Path.make(Path.dir(cache_path))
		File.open(cache_path,'w') { |file| file.puts( Crypt.encrypt( YAML::dump( message_threads ))) }
	end
	
	def self.threads(dataset)
		project_threads = dataset.map
		cache_path = Path.catname(CACHE_ROOT,"projects/#{project_threads[0][:project_id].to_s}.cache")
		Path.make(Path.dir(cache_path))
		File.open(cache_path,'w') { |file| file.puts( Crypt.encrypt( YAML::dump( project_threads ))) }
	end
	
	def self.projects(dataset)
		File.open(Path.catname(CACHE_ROOT,'projects.cache'),'w') do |file|
			file.puts( Crypt.encrypt( YAML::dump( dataset.map)))
		end
	end
	
	
	
	
end
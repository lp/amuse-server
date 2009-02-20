class SerialCache
	require 'yaml'
	require 'app/helpers/path'
	require 'app/helpers/crypt'
	include Crypt
	
	CACHE_ROOT = 'app/data/cache'
	
	def self.dashboard(dataset)
		last_id = dataset.last.map(:id); first_id = last_id - 10; first_id = 0 if first_id < 0
		File.open(Path.catname(CACHE_ROOT,'dashboard.cache'),'w') do |file|
			file.puts( encrypt( YAML::dump( @db[:store].filter(:id => first_id..last_id).map )))
		end
	end
	
	def self.thread(dataset)
		thread_array = dataset.map
		cache_path = Path.catname(CACHE_ROOT,"#{thread_array[0][:project_id].to_s}/#{thread_array[0][:thread_id].to_s}.cache")
		Path.make(Path.dir(cache_path))
		File.open(cache_path,'w') { |file| file.puts( encrypt( YAML::dump( thread_array ))) }
	end
	
	
end
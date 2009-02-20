class SerialCache
	require 'yaml'
	require 'app/helpers/path'
	require 'app/helpers/crypt'
	include Crypt
	
	CACHE_ROOT = 'app/data/cache'
	
	def self.dashboard(dash_array)
		File.open(Path.catname(CACHE_ROOT,'dashboard.cache'),'w') do |file|
			file.puts(encrypt(YAML::dump(dash_array)))
		end
	end
	
	
end
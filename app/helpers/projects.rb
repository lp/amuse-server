module Projects
	require 'yaml'
	
	def projects=(message=nil)
		@projects = Dir.pwd
	end 
	
	def projects(message=nil)
		YAML::dump(Dir.entries('data/files').delete_if { |item| item.match(/^\./) })
	end
	
	def fill(data)
		@big_data_container = data
	end

	def display
		@big_data_container
	end
	
end





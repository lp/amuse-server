module Path
	require 'ftools'
	
	def Path.dir(path)
		File.dirname(path)
	end
	
	def Path.make(path)
		File.makedirs(path)
	end
	
end
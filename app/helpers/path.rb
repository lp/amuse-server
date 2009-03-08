# Author:: lp (mailto:lp@spiralix.org)
# Copyright:: 2009 Louis-Philippe Perron - Released under the terms of the MIT license
# 
# :title:amuse-server/path
module Path
	require 'ftools'
	
	def Path.dir(path)
		File.dirname(path)
	end
	
	def Path.make(path)
		File.makedirs(path)
	end
	
end
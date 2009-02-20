module Path
	require 'ftools'
	
	def Path.catname(first,last)
		first << '/' if first[/\/$/].nil?
		last[0] = '' if ! last[/^\//].nil?
		first + last
	end
	
	def Path.dir(path)
		File.dirname(path)
	end
	
	def Path.make(path)
		File.makedirs(path)
	end
	
end
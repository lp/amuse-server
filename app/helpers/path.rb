module Path
	
	def Path.catname(first,last)
		first << '/' if first[/\/$/].nil?
		last[0] = '' if ! last[/^\//].nil?
		first + last
	end
	
end
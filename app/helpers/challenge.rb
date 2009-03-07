class Challenge
	require File.join( File.dirname( File.expand_path(__FILE__)), 'random')
	
	attr_reader :challenge, :response
	def initialize
		@challenge = [Random.operator, Random.number( rand(4)+2), Random.number( rand(4)+2)]
		@response = eval(@challenge[1].to_s+@challenge[0]+@challenge[2].to_s)
	end
	
end
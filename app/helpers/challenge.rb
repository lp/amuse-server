# Author:: lp (mailto:lp@spiralix.org)
# Copyright:: 2009 Louis-Philippe Perron - Released under the terms of the MIT license
# 
# :title:amuse-server/challenge
class Challenge
	require File.join( File.dirname( File.expand_path(__FILE__)), 'random')
	
	attr_reader :challenge, :response
	def initialize
		@challenge = [Random.operator, Random.float( (rand(4)+2)), Random.float( (rand(4)+2))]
		@response = eval(@challenge[1].to_s+@challenge[0]+@challenge[2].to_s).to_s
		puts "challenge: #{@challenge.inspect} response: #{@response.inspect}"
	end
	
end
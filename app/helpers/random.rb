# Author:: lp (mailto:lp@spiralix.org)
# Copyright:: 2009 Louis-Philippe Perron - Released under the terms of the MIT license
# 
# :title:amuse-server/random
module Random
	
	ALPHABET = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z]
	OPERATORS = %w[+ - * /]
	
	def Random.keys(num,length=256)
		keys = Array.new
		num.times do
			keys << Random.string(length)
		end
		return keys
	end
		
	def Random.string(length)
		string = ''
		length.times do
			string << Random.letter
		end
		return string
	end
	
	def Random.letter
		ALPHABET[rand(26)]
	end
	
	def Random.float(size)
		number = ''
		size.times { number << rand(10).to_s }
		number.to_f
	end
	
	def Random.operator
		OPERATORS[rand(4)]
	end
	
end

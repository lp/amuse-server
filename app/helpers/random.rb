module Random
	
	ALPHABET = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z]
	
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
	
end

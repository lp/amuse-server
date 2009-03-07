require File.join( File.dirname( File.expand_path(__FILE__)), 'key_store')

class AuthDoor
	
	def call(env)
		req = Rack::Request.new(env)
		
		
	end
	
end

class AuthKeys
	
	def call(env)
		req = Rack::Request.new(env)
		
	end
	
end
	
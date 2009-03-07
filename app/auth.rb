require File.join( File.dirname( File.expand_path(__FILE__)), 'key_store')

class AuthKeys
	
	def call(env)
		req = Rack::Request.new(env)
		if req[:r].nil?
			KeyStore.challenge(req[:a])
		else
			if Keystore.response?(req[:a],req[:r])
				keys = KeyStore.author_keys(req[:a])
				[200, {	'Content-Type' => 'text/plain', 'Content-Length' => keys.size.to_s},keys]
			else
				[403, headers, "Go Away!!"]
			end
		end
	end
	
end

module Rack
	class AuthDoor
		
		def initialize app
			@app = app
		end

		def call(env)
			req = Rack::Request.new(env)
			status, headers, body = @app.call env
			if KeyStore.authorized?(req[:a],req[:k])
				[status, headers, body]
			else
				[403, headers, "Go Away!!"]
			end
		end

	end
end
	
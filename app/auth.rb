require File.join( File.dirname( File.expand_path(__FILE__)), 'key_store')
# Author:: lp (mailto:lp@spiralix.org)
# Copyright:: 2009 Louis-Philippe Perron - Released under the terms of the MIT license
# 
# :title:amuse-server/auth
class AuthKeys
	
	def call(env)
		req = Rack::Request.new(env)	
		if req[:r].nil?
			KeyStore.challenge(req[:a])
		else
			if Keystore.response?(req[:a],req[:r])
				if req[:a] == 'ipkey'
					key = KeyStore.ip_key(req.ip)
					[200, {	'Content-Type' => 'text/plain', 'Content-Length' => key.size.to_s},key]
				else
					keys = KeyStore.author_keys(req[:a])
					[200, {	'Content-Type' => 'text/plain', 'Content-Length' => keys.size.to_s},keys]
				end
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
	
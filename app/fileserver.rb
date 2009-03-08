# Author:: lp (mailto:lp@spiralix.org)
# Copyright:: 2009 Louis-Philippe Perron - Released under the terms of the MIT license
# 
# :title:amuse-server/fileserver
class Server
	def initialize(root)
		@root = root
	end
end

class FileServer < Server
	def call(env)
		file_path = File.join(@root,env["PATH_INFO"])
		if File.exist?(file_path)
			[200, {	'Content-Type' => 'application/octet-stream',
							'Content-Length' => File.size(file_path).to_s},
							FileStreamer.new(file_path)]
		else
			[404, {	'Content-Type' => 'text/plain' }, 'Sorry, File Not Found']
		end
	end
end

class CacheServer < Server
	def call(env)
		file_path = File.join(@root,env["PATH_INFO"])
		file_path = File.join(@root,'/empty.cache') unless File.exist?(file_path)
		[200, {	'Content-Type' => 'application/octet-stream',
						'Content-Length' => File.size(file_path).to_s},
						FileStreamer.new(file_path)]
	end
end

class FileReceive < Server
	
	def call(env)
		req = Rack::Request.new(env); filepath = File.join(@root, env['PATH_INFO'])
		Path.make( Path.dir( filepath))
		File.delete(filepath) if File.exist?(filepath) and req[:part].to_i == 1
		File.open(filepath,'a+') do |file|
			file.print( req[:upload].chomp)
		end
		[200, {	'Content-Type' => 'text/plain', 'Content-Length' => 2.to_s},'OK']
	end
	
end

class FileStreamer
	def initialize(file)
		@file = file
	end
	
	def each
		File.open(@file,'r') do |file|
			while part = file.read(1024)
				yield part
			end
		end
	end
end

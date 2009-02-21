class Server
	def initialize(root)
		@root = root
	end
end

class FileServer < Server
	def call(env)
		path = env["PATH_INFO"]; file_path = @root + path
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
		path = env["PATH_INFO"]; file_path = @root + path
		file_path = @root + '/empty.cache' unless File.exist?(file_path)
		[200, {	'Content-Type' => 'application/octet-stream',
						'Content-Length' => File.size(file_path).to_s},
						FileStreamer.new(file_path)]
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

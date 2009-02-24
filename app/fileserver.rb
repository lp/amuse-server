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

class FileReceive < Server
	# @@request_buffer = Hash.new
	
	def call(env)
		req = Rack::Request.new(env); filepath = Path.catname(@root, env['PATH_INFO'])
		# puts "request buffer: #{@@request_buffer.inspect}"
		Path.make( Path.dir( filepath))
		File.delete(filepath) if File.exist?(filepath) and req[:part].to_i == 1
		File.open(filepath,'a+') do |file|
			file.print( req[:upload].chomp)
		end
		[200, {	'Content-Type' => 'text/plain', 'Content-Length' => 2.to_s},'OK']
	end
	
	# def next_part(req)
	# 		puts "request buffer part: #{@@request_buffer.inspect}"
	# 		if @@request_buffer[req[:digest]].nil?
	# 			@@request_buffer[req[:digest]] = {:part => req[:part].to_i, :buffer => Hash.new}
	# 			return req[:upload].chomp
	# 		else
	# 			if @@request_buffer[req[:digest]][:part] + 1 == req[:part].to_i
	# 				@@request_buffer[req[:digest]][:part] = req[:part].to_i
	# 				return req[:upload].chomp
	# 			elsif ! @@request_buffer[req[:digest]][:buffer][@@request_buffer[req[:digest]][:part]+1].nil?
	# 				buffer = @@request_buffer[req[:digest]][:buffer][@@request_buffer[req[:digest]][:part]+1]
	# 				@@request_buffer[req[:digest]][:buffer][@@request_buffer[req[:digest]][:part]+1] = nil
	# 				return buffer
	# 			else
	# 				@@request_buffer[req[:digest]][:buffer][req[:part].to_i] = req[:upload].chomp
	# 				return false
	# 			end
	# 		end
	# 	end
	
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

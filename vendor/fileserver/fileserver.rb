class FileServer
	
	def initialize(root)
		@root = root
	end
	
	def call(env)
		path = env["PATH_INFO"]
		file = FileEncoder.new(@root + path)
		[200, {'Content-Type' => 'text/plain', 'Content-Length' => file.length.to_s}, file]
	end
	
end

class FileEncoder
	def initialize(file)
		@file = file
	end
	
	def length
		File.size(@file)
	end
	
	def each
		File.open(@file,'r') do |file|
			while part = file.read(8192)
				yield part
			end
		end
	end
	
end
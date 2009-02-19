module Crypt
	require 'openssl'
	require 'yaml'
	
	File.open('app/amuse.conf','r') do |f|
		content = YAML::load(f.read)
		IV = content[:iv]
		KEY = content[:key]
	end
	
	def encrypt(data)
		c = OpenSSL::Cipher::Cipher.new("bf-cbc")
		c.encrypt; c.key = KEY; c.iv = IV
		e = c.update(data); e << c.final
		e
	end

	def decrypt(data)
		data
	end
	
end
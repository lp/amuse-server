# top level, main Object
unless File.exist?(File.join( File.dirname( File.expand_path(__FILE__)), '..', '..', 'data'))
	require 'ftools'
	require 'yaml'
	require File.join( File.dirname( File.expand_path(__FILE__)), 'crypt')
	
	root = File.dirname( File.expand_path(__FILE__))
	['cache','db','files'].each do |mydir|
		File.makedirs( File.join( root, '..', '..', 'data', mydir))
	end
	File.open( File.join( root, '..', '..', 'data', 'cache', 'empty.cache' ), 'w') do |file|
		file.puts Crypt.encrypt( YAML::dump( nil))
	end
end

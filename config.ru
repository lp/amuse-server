require File.join( File.dirname( File.expand_path(__FILE__)), 'vendor', 'rack', 'lib', 'rack')
require File.join( File.dirname( File.expand_path(__FILE__)), 'vendor', 'sinatra', 'lib', 'sinatra')
require File.join( File.dirname( File.expand_path(__FILE__)), 'app', 'fileserver')

disable :run
set :app_file, File.join( File.dirname( File.expand_path(__FILE__)), 'app', 'app.rb')
require File.join( File.dirname( File.expand_path(__FILE__)), 'app', 'app')

map '/cache' do
	run CacheServer.new( File.join( File.dirname( File.expand_path(__FILE__)), 'data', 'cache'))
end

map '/files' do
	run FileServer.new( File.join( File.dirname( File.expand_path(__FILE__)), 'data', 'files'))
end

map '/app' do
	run Sinatra::Application
end

map '/upload' do
	run FileReceive.new( File.join( File.dirname( File.expand_path(__FILE__)), 'data', 'files'))
end

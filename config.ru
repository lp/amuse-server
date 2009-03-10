require File.join( File.dirname( File.expand_path(__FILE__)), 'app', 'helpers', 'environment')
require File.join( File.dirname( File.expand_path(__FILE__)), 'vendor', 'rack', 'lib', 'rack')
require File.join( File.dirname( File.expand_path(__FILE__)), 'vendor', 'sinatra', 'lib', 'sinatra')
require File.join( File.dirname( File.expand_path(__FILE__)), 'app', 'fileserver')
require File.join( File.dirname( File.expand_path(__FILE__)), 'app', 'auth')

require File.join( File.dirname( File.expand_path(__FILE__)), 'app','message_store')
require File.join( File.dirname( File.expand_path(__FILE__)), 'app','key_store')
KeyStore.setup; MessageStore.setup

disable :run
set :app_file, File.join( File.dirname( File.expand_path(__FILE__)), 'app', 'app.rb')
require File.join( File.dirname( File.expand_path(__FILE__)), 'app', 'app')

map '/cache' do
	use Rack::AuthDoor
	run CacheServer.new( File.join( File.dirname( File.expand_path(__FILE__)), 'data', 'cache'))
end

map '/files' do
	use Rack::AuthDoor
	run FileServer.new( File.join( File.dirname( File.expand_path(__FILE__)), 'data', 'files'))
end

map '/app' do
	use Rack::AuthDoor
	run Sinatra::Application
end

map '/upload' do
	use Rack::AuthDoor
	run FileReceive.new( File.join( File.dirname( File.expand_path(__FILE__)), 'data', 'files'))
end

map '/auth' do
	run AuthKeys.new
end

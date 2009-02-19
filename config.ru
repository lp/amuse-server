require 'vendor/rack/lib/rack'
require 'vendor/sinatra/lib/sinatra'
require 'vendor/fileserver/fileserver'

disable :run
set :app_file, "app/app.rb"
require 'app/app'

map '/messages' do
	run FileServer.new('data/messages')
end

map '/files' do
	run FileServer.new('data/files')
end

map '/app' do
	run Sinatra::Application
end

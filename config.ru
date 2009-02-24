require 'vendor/rack/lib/rack'
require 'vendor/sinatra/lib/sinatra'
require 'app/fileserver'

disable :run
set :app_file, "app/app.rb"
require 'app/app'

map '/cache' do
	run CacheServer.new('data/cache')
end

map '/files' do
	run FileServer.new('data/files')
end

map '/app' do
	run Sinatra::Application
end

map '/multi/new' do
	run FileReceive.new('data/files')
end

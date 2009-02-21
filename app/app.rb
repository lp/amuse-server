require 'yaml'

require 'app/helpers/projects'
require 'app/helpers/messages'
require 'app/helpers/threads'
require 'app/helpers/crypt'
require 'app/message_store'

helpers do
	include AmuseHelpers
end

post '/new/author' do
	Crypt.encrypt( MessageStore.new_author( YAML::load( Crypt.decrypt( params[:o]))))
end

post '/new/project' do
	Crypt.encrypt( MessageStore.new_project( YAML::load( Crypt.decrypt( params[:o]))))
end

post '/new/thread' do
	Crypt.encrypt( MessageStore.new_thread( YAML::load( Crypt.decrypt( params[:o]))))
end

post '/new/message' do
	Crypt.encrypt( MessageStore.new_message( YAML::load( Crypt.decrypt( params[:o]))))
end

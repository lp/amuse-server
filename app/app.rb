require 'yaml'

require 'app/helpers/projects'
require 'app/helpers/messages'
require 'app/helpers/threads'
require 'app/helpers/crypt'
require 'app/message_store'

helpers do
	include AmuseHelpers
end

post '/authors/new' do
	Crypt.encrypt( MessageStore.new_author( YAML::load( Crypt.decrypt( params[:o]))).to_s)
end

post '/projects/new' do
	Crypt.encrypt( MessageStore.new_project( YAML::load( Crypt.decrypt( params[:o]))).to_s)
end

post '/threads/new' do
	Crypt.encrypt( MessageStore.new_thread( YAML::load( Crypt.decrypt( params[:o]))).to_s)
end

post '/messages/new' do
	Crypt.encrypt( MessageStore.new_message( YAML::load( Crypt.decrypt( params[:o]))).to_s)
end

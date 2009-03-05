require 'yaml'

require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers', 'projects')
require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers', 'messages')
require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers', 'threads')
require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers', 'crypt')
require File.join( File.dirname( File.expand_path(__FILE__)), 'message_store')

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

post '/keys' do
	Crypt.encrypt( YAML::dump( KeyStore.author_keys( Crypt.decrypt( params[:o]))))
end

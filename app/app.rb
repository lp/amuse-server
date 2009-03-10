# Author:: lp (mailto:lp@spiralix.org)
# Copyright:: 2009 Louis-Philippe Perron - Released under the terms of the MIT license
# 
# :title:amuse-server/app
require 'yaml'

require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers', 'projects')
require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers', 'messages')
require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers', 'threads')
require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers', 'crypt')
# require File.join( File.dirname( File.expand_path(__FILE__)), 'message_store')
# require File.join( File.dirname( File.expand_path(__FILE__)), 'key_store')

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

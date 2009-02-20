require 'app/helpers/projects'
require 'app/helpers/crypt'
require 'app/message_store'

helpers do
	include Projects
	include Crypt
end

get '/projects' do
	encrypt projects
end

get '/projects/messages/:thread' do
	"Under construction"
end

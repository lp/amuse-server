require 'app/helpers/projects'
require 'app/helpers/crypt'

class Counter
	
	@@count = 0
	
	def Counter::num
		@@count += 1
		@@count.to_s
	end
	
end

helpers do
	include Projects
	include Crypt
end

get '/' do
	"Worked on Dreamhost: #{Counter::num}"
end

get '/foo/:bar/:goo' do
	"You asked for foo/#{params[:bar]}/#{params[:goo]}"
end

get '/projects' do
	encrypt projects
end

get '/projects/messages/:thread' do
	"Under construction"
end

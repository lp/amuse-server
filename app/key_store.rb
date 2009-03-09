# Author:: lp (mailto:lp@spiralix.org)
# Copyright:: 2009 Louis-Philippe Perron - Released under the terms of the MIT license
# 
# :title:amuse-server/key_store
module KeyStore
	require File.join( File.dirname( File.expand_path(__FILE__)), '..', 'vendor', 'sequel', 'lib', 'sequel')
	require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers', 'random')
	require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers', 'crypt')
	require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers', 'challenge')
	DB_PATH = File.join( File.dirname( File.expand_path(__FILE__)), '..', 'data', 'db', 'key_store.db')
	@@db = Sequel.sqlite(DB_PATH)
	begin
		@@db.create_table :challenge do
			primary_key :id
			column :created, :integer
			column :author_id, :integer
			column :response, :float
		end
	rescue Sequel::DatabaseError
	end
	begin
		@@db.create_table :ipkey do
			primary_key :id
			column :ip, :text
			column :key, :text
		end
	rescue Sequel::DatabaseError
	end
	
	def KeyStore.ip_key(ip)
		@@db[:ipkey].filter(:ip => ip).delete
		key = Random.string(256)
		@@db[:ipkey] << {:ip => ip, :key => key}
		Crypt.encrypt( key)
	end
	
	def KeyStore.author_keys(author_id)
		keys = Random.keys(256,256)
		clean_author_keys_table(author_id)
		keys.each do |key|
			@@db[author_id.to_sym] << {:key => key}
		end
		Crypt.encrypt( YAML::dump( keys))
	end
	
	def KeyStore.authorized?(author_id,key)
		if author_id.nil?
			return false
		else
			result = @@db[author_id.to_sym].filter(:key => key).delete
			if result == 0
				return false
			elsif result > 0
				return true
			else
				return false
			end
		end
	end
	
	def KeyStore.challenge(author_id)
		@@db[:challenge].filter(:author_id => author_id).delete
		c = Challenge.new
		@@db[:challenge] << {:created => Time.now.to_i, :author_id => author_id, :response => c.response}
		Crypt.encrypt( YAML::dump( c.challenge))
	end
	
	def KeyStore.response?(author_id,response)
		response = Crypt.decrypt(response).to_f
		row = @@db[:challenge].filter(:author_id => author_id)
		if Time.now.to_i > (row.map(:created).first+50)
			return false
		elsif row.map(:response).first == response
			row.delete
			return true
		else
			return false
		end
	end
	
	private
	
	def clean_author_keys_table(author_id)
		begin
			@@db.create_table author_id.to_sym do
				primary_key :id
				column :created, :datetime
				column :key, :text
			end
		rescue Sequel::DatabaseError
		end
		@@db[author_id.to_sym].all.delete
	end
	
end
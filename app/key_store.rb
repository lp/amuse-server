module KeyStore
	require File.join( File.dirname( File.expand_path(__FILE__)), '..', 'vendor', 'sequel', 'lib', 'sequel')
	require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers', 'random')
	require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers', 'crypt')
	DB_PATH = File.join( File.dirname( File.expand_path(__FILE__)), '..', 'data', 'db', 'key_store.db')
	@@db = Sequel.sqlite(DB_PATH)
	
	def KeyStore.author_keys(author_id)
		keys = Random.keys(256,256)
		clean_author_keys_table(author_id)
		keys.each do |key|
			@db[author_id.to_sym] << {:key => key}
		end
		Crypt.encrypt( YAML::dump( keys))
	end
	
	def KeyStore.authorized?(author_id,key)
		result = @db[author_id.to_sym].filter(:key => Crypt.decrypt( key)).delete
		if result == 0
			return false
		elsif result > 0
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
		@db[author_id.to_sym].all.delete
	end
	
end
module MessageStore
	require 'sequel'
	require 'app/serial_cache'
	DB_PATH = 'app/data/db/message_store.db'
	
	@@db = Sequel.sqlite(DB_PATH)
	begin
		@@db.create_table :messages do
			primary_key :id
			column :project_id, :integer
			column :thread_id, :integer
			column :authors_id, :integer
			column :datetime, :datetime
			column :title, :text
			column :message, :text
		end
	rescue Sequel::DatabaseError
	end
	begin
		@@db.create_table :threads do
			primary_key :id
			column :subject, :text
			column :project_id, :integer 
		end
	rescue Sequel::DatabaseError
	end
	begin
		@@db.create_table :projects do
			primary_key :id
			column :name, :text
			column :description, :text
		end
	rescue Sequel::DatabaseError
	end
	begin
		@@db.create_table :authors do
			primary_key :id
			column :name, :text
			column :avatar, :text
			column :nickname, :text 
		end
	rescue Sequel::DatabaseError
	end
	
	def MessageStore.new_author(author_hash)
		@@db[:authors] << author_hash; new_author_id = @@db[:authors].last
		SerialCache.authors(@@db[:authors])
		new_author_id
	end
	
	def MessageStore.new_message(row_hash)
		@@db[:messages] << row_hash; new_message_id = @@db[:messages].last
		SerialCache.dashboard(@@db[:messages])
		SerialCache.messages(@@db[:messages].where(:thread_id => row_hash[:thread_id]))
		new_message_id
	end
	
	def MessageStore.new_thread(message_hash)
		@@db[:threads] << message_hash; new_thread_id = @@db[:threads].last
		SerialCache.threads(@@db[:threads].where(:project_id => message_hash[:project_id]))
		new_thread_id
	end
	
	def MessageStore.new_project(project_hash)
		@@db[:projects] << project_hash; new_project_id = @@db[:projects].last
		SerialCache.projects(@@db[:projects])
		new_project_id
	end
	
end
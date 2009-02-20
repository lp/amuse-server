module MessageStore
	require 'sequel'
	require 'app/helpers/serial_cache'
	DB_PATH = 'app/data/db/message_store.db'
	
	@@db = Sequel.sqlite(DB_PATH)
	begin
		@@db.create_table :messages do
			primary_key :id
			column :project_id, :integer
			column :project, :text
			column :thread_id, :integer
			column :subject, :text 
			column :author, :text
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
	
	def MessageStore.read_thread(id)
		@@db[:messages].where(:thread_id => id).reverse_order(:id).map
	end
	
	def MessageStore.new_message(row_hash)
		@@db[:messages] << row_hash
		SerialCache.dashboard(@@db[:messages])
		SerialCache.messages(@@db[:messages].where(:thread_id => row_hash[:thread_id]))
	end
	
	def MessageStore.new_thread(subject,project_id)
		@@db[:threads] << {:subject => subject, :project_id => project_id}
		SerialCache.threads(@@db[:threads].where(:project_id => project_id))
		@@db[:threads].where(:subject => subject).map(:id).last
	end
	
	def MessageStore.new_project(name)
		@@db[:projects] << {:name => name}
		SerialCache.projects(@@db[:projects])
		@@db[:projects].where(:name => name).map(:id).last
	end
	
end
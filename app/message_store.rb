class MessageStore
	require 'sequel'
	require 'app/helpers/serial_cache'
	
	def initialize(path)
		store = path + '.blob'
		@db = Sequel.sqlite(store)
		begin
			@db.create_table :store do
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
			@db.create_table :threads do
				primary_key :id
				column :subject, :text
				column :project_id, :integer 
			end
			@db.create_table :projects do
				primary_key :id
				column :name, :text
			end
		rescue Sequel::DatabaseError
		end
	end
	
	def self.open(path)
		self.new(path)
	end
	
	def read_thread(id)
		@db[:store].where(:thread_id => id).reverse_order(:id).map
	end
	
	def new_message(row_hash)
		@db[:store] << row_hash
		SerialCache.dashboard(@db[:store])
		SerialCache.thread(@db[:store].where(:thread_id => row_hash[:thread_id]))
	end
	
	def new_project(name)
		@db[:projects] << {:name => name}
		@db[:projects].where(:name => name).map(:id).last
	end
	
	def new_thread(subject,project_id)
		@db[:threads] << {:subject => subject, :project_id => project_id}
		@db[:threads].where(:subject => subject).map(:id).last
	end
	
end
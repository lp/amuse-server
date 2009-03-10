# Author:: lp (mailto:lp@spiralix.org)
# Copyright:: 2009 Louis-Philippe Perron - Released under the terms of the MIT license
# 
# :title:amuse-server/message_store
module MessageStore
	require File.join( File.dirname( File.expand_path(__FILE__)), '..', 'vendor', 'sequel', 'lib', 'sequel')
	require File.join( File.dirname( File.expand_path(__FILE__)), 'serial_cache')
	require File.join( File.dirname( File.expand_path(__FILE__)), 'helpers', 'random')
	DB_PATH = File.join( File.dirname( File.expand_path(__FILE__)), '..', 'data', 'db', 'message_store.db')
	
	def MessageStore.setup
		unless File.exist?(DB_PATH)
			@@db = Sequel.sqlite(DB_PATH)
			begin
				@@db.create_table :projects do
					primary_key :id
					column :created, :integer
					column :name, :text
					column :description, :text
				end
			rescue Sequel::DatabaseError
			end

			begin
				@@db.create_table :threads do
					primary_key :id
					column :created, :integer
					column :subject, :text
					column :project_id, :integer 
				end
			rescue Sequel::DatabaseError
			end
			begin
				@@db.create_table :authors do
					primary_key :id
					column :created, :integer
					column :last_login, :integer
					column :name, :text
					column :email, :text
					column :avatar, :text
					column :nickname, :text
					column :status, :text
				end
			rescue Sequel::DatabaseError
			end

			begin
				@@db.create_table :files do
					primary_key :id
					column :created, :integer
					column :local_path, :text
					column :author_id, :integer
					column :project_id, :integer
					column :type, :text
					column :description, :text
					column :attribute, :text
				end
			rescue Sequel::DatabaseError
			end	
			begin
				@@db.create_table :messages do
					primary_key :id
					column :created, :integer
					column :project_id, :integer
					column :thread_id, :integer
					column :author_id, :integer
					column :title, :text
					column :message, :text
				end
			rescue Sequel::DatabaseError
			end
		else
			@@db = Sequel.sqlite(DB_PATH)
		end
	end
	
	def MessageStore.new_author(author_hash)
		author_hash[:created] = Time.now.to_i
		@@db[:authors] << author_hash; new_author_id = @@db[:authors].order(:id).last[:id]
		SerialCache.authors(@@db[:authors])
		new_author_id
	end
	
	def MessageStore.new_message(row_hash)
		row_hash[:created] = Time.now.to_i
		@@db[:messages] << row_hash; new_message_id = @@db[:messages].order(:id).last[:id]
		SerialCache.dashboard(@@db[:messages])
		SerialCache.messages(@@db[:messages].where(:thread_id => row_hash[:thread_id]))
		new_message_id
	end
	
	def MessageStore.new_thread(message_hash)
		message_hash[:created] = Time.now.to_i
		@@db[:threads] << message_hash; new_thread_id = @@db[:threads].order(:id).last[:id]
		SerialCache.threads(@@db[:threads].where(:project_id => message_hash[:project_id]))
		new_thread_id
	end
	
	def MessageStore.new_project(project_hash)
		project_hash[:created] = Time.now.to_i
		@@db[:projects] << project_hash; new_project_id = @@db[:projects].order(:id).last[:id]
		SerialCache.projects(@@db[:projects])
		new_project_id
	end
	
end
module FileStore
	require 'app/helpers/path'
	STORE_ROOT = 'data/files'
	
	def FileStore.save(folder,filename,data)
		Path.make( Path.catname(STORE_ROOT,folder))
		File.open( Path.catname( Path.catname(STORE_ROOT,folder),filename),'w') do |file|
			file.print( data)
		end
	end
	
end
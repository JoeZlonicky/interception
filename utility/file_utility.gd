class_name FileUtility


static func get_all_files_under_folder(folder_path: String,
		file_ending: String = "") -> Array[String]:
	var paths: Array[String] = []
	folder_path = folder_path.trim_suffix("/")  # Will be appended manually
	var directory_paths_queue: Array[String] = [folder_path]
	
	while directory_paths_queue.size() > 0:
		var current_director_path: String = directory_paths_queue.pop_front()
		var current_directory: DirAccess = DirAccess.open(current_director_path)
		current_directory.list_dir_begin()
		
		var file_name: String = current_directory.get_next()
		while file_name != "":
			var current_file_path: String = current_director_path + "/" + file_name
			# .remap suffixes are appended to files of exported projects
			current_file_path = current_file_path.trim_suffix(".remap")
			
			if current_directory.current_is_dir():
				directory_paths_queue.push_back(current_file_path)
			elif file_name.ends_with(file_ending):
				paths.append(current_file_path)
			
			file_name = current_directory.get_next()
		
		current_directory.list_dir_end()
	
	return paths

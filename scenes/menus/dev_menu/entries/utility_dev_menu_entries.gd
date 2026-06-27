class_name UtilityDevMenuEntries


static func get_entries() -> Dictionary[String, Callable]:
	var entries: Dictionary[String, Callable] = {}
	entries["Toggle Fullscreen"] = DisplayUtility.toggle_fullscreen
	return entries

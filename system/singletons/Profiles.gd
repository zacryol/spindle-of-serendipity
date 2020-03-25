extends Node

const RESERVED := "Default (All Entries)"
var profiles_dict: Dictionary # string for key, Profile object as value

func _ready() -> void:
	load_from_file()


func save_profile(id: String,
		cat: PoolStringArray, sou: PoolStringArray, both: bool) -> void:
	if profiles_dict.has(id):
		profiles_dict[id].free()
		profiles_dict.erase(id)
	profiles_dict[id] = Profile.new(cat, sou, both)
	write_to_file()


func get_keys() -> PoolStringArray:
	return PoolStringArray(profiles_dict.keys())


func get_profile_data(id: String) -> Dictionary:
	if profiles_dict.has(id):
		return profiles_dict[id].get_data()
	else:
		return {}


func write_to_file() -> void:
	var f := File.new()
	f.open(GlobalVars.PROFILE_SAVE, File.WRITE)
	for k in profiles_dict.keys():
		var store_dict := {
			"id" : k,
			"data" : get_profile_data(k)
		}
		f.store_line(to_json(store_dict))


func load_from_file() -> void:
	var f := File.new()
	if not f.file_exists(GlobalVars.PROFILE_SAVE):
		return
	var err = f.open(GlobalVars.PROFILE_SAVE, File.READ)
	if err:
		return
	
	while not f.eof_reached():
		var data := f.get_line()
		if not data:
			continue
		
		var v = validate_json(data)
		if v:
			continue
		
		var d = parse_json(data)
		if typeof(d) == TYPE_DICTIONARY:
			var dict := d as Dictionary
			if dict.has_all(["id", "data"]):
				var profile_data := dict["data"] as Dictionary
				var id: String = dict["id"]
				if profile_data.has_all(["both", "cat", "sou"]):
					if profiles_dict.has(id):
						profiles_dict[id].free()
						profiles_dict.erase(id)
					profiles_dict[id]\
							= Profile.new(profile_data["cat"], 
									profile_data["sou"],
									profile_data["both"])


func clear(id: String):
	if profiles_dict.has(id):
		profiles_dict[id].free()
		profiles_dict.erase(id)
		write_to_file()


class Profile extends Object:
	var match_both: bool
	var categories: PoolStringArray
	var sources: PoolStringArray
	
	func _init(cat: PoolStringArray, sou: PoolStringArray, both: bool) -> void:
		categories = cat
		sources = sou
		match_both = both
	
	
	func get_data() -> Dictionary:
		return {
			"both" : match_both,
			"cat" : categories,
			"sou" : sources
		}
	
	
	func append_category(cat: String) -> void:
		categories.append(cat)
	
	
	func append_source(sou: String) -> void:
		sources.append(sou)
	
	
	func contains_entry(e: Entry) -> bool:
		if match_both:
			return contains_category(e.get_import_category().to_lower())\
					and contains_source(e.get_import_source().to_lower())
		else:
			return contains_category(e.get_import_category().to_lower())\
					or contains_source(e.get_import_source().to_lower())
	
	
	func contains_category(cat: String) -> bool:
		if categories.empty():
			return true
		else:
			return cat.to_lower() in categories
	
	
	func contains_source(sou: String) -> bool:
		if sources.empty():
			return true
		else:
			return sou.to_lower() in sources
	

extends Node

const RESERVED := "Default (All Entries)"
var profiles_dict: Dictionary


func _ready() -> void:
	load_from_file()


func save_profile(id: String,
		cat: PoolStringArray, sou: PoolStringArray, count: int) -> void:
	profiles_dict[id] = {
		'cat' : cat,
		'sou' : sou,
		'match_count' : count,
	}
#	if profiles_dict.has(id):
#		profiles_dict[id].free()
#		profiles_dict.erase(id)
#	profiles_dict[id] = Profile.new(cat, sou, both)
	write_to_file()


func get_keys() -> PoolStringArray:
	return PoolStringArray(profiles_dict.keys())


func get_profile_data(id: String) -> Dictionary:
	if profiles_dict.has(id):
		return profiles_dict[id]
	else:
		return {}


func write_to_file() -> void:
	var f := File.new()
	var err := f.open(GlobalVars.PROFILE_SAVE, File.WRITE)
	if err:
		return
	f.store_var(profiles_dict)
	f.close()
#	for k in profiles_dict.keys():
#		var store_dict := {
#			"id" : k,
#			"data" : get_profile_data(k)
#		}
#		f.store_line(to_json(store_dict))


func load_from_file() -> void:
	var f := File.new()
	if not f.file_exists(GlobalVars.PROFILE_SAVE):
		return
	var err = f.open(GlobalVars.PROFILE_SAVE, File.READ)
	if err:
		return
	var p = f.get_var()
	if not typeof(p) == TYPE_DICTIONARY:
		return
	
	profiles_dict = p
	
#	while not f.eof_reached():
#		var data := f.get_line()
#		if not data:
#			continue
#
#		var v = validate_json(data)
#		if v:
#			continue
#
#		var d = parse_json(data)
#		if typeof(d) == TYPE_DICTIONARY:
#			var dict := d as Dictionary
#			if dict.has_all(["id", "data"]):
#				var profile_data := dict["data"] as Dictionary
#				var id: String = dict["id"]
#				if profile_data.has_all(["both", "cat", "sou"]):
#					if profiles_dict.has(id):
#						profiles_dict[id].free()
#						profiles_dict.erase(id)
#					profiles_dict[id]\
#							= Profile.new(profile_data["cat"], 
#									profile_data["sou"],
#									profile_data["both"])


func clear(id: String):
	if profiles_dict.has(id):
#		profiles_dict[id].free()
		profiles_dict.erase(id)
		write_to_file()


func profile_has_entry(e: Entry, pid: String) -> bool:
	if not profiles_dict.has(pid):
		return true
	var p := profiles_dict[pid] as Dictionary
	var c := get_profile_match_count(e, p)
	assert(p.has('match_count'))
	return c >= p.match_count


func get_profile_match_count(e: Entry, p: Dictionary) -> int:
	var count = 0
	assert(p.has_all(['cat', 'sou']))
	if e.get_import_category() in p['cat']:
		count += 1
	if e.get_import_source() in p['sou']:
		count += 1
	
	return count

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
			return contains_category(e.get_import_category())\
					and contains_source(e.get_import_source())
		else:
			return contains_category(e.get_import_category())\
					or contains_source(e.get_import_source())
	
	
	func contains_category(cat: String) -> bool:
		if categories.empty():
			return true
		else:
			return cat in categories
	
	
	func contains_source(sou: String) -> bool:
		if sources.empty():
			return true
		else:
			return sou in sources

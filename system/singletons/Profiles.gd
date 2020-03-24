extends Node

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


func write_to_file() -> void:
	var f := File.new()
	f.open(GlobalVars.PROFILE_SAVE, File.WRITE)
	for k in profiles_dict.keys():
		f.store_line(k)
		f.store_line("true" if profiles_dict[k].match_both else "false")
		f.store_csv_line(profiles_dict[k].categories)
		f.store_csv_line(profiles_dict[k].sources)


func load_from_file() -> void:
	var f := File.new()
	f.open(GlobalVars.PROFILE_SAVE, File.READ)
	while not f.eof_reached():
		var id: String = f.get_line()
		if not id:
			continue
		var both: bool = true if f.get_line() == "true" else false
		var cat := f.get_csv_line()
		var sou := f.get_csv_line()
		
		if profiles_dict.has(id):
			profiles_dict[id].free()
			profiles_dict.erase(id)
		
		profiles_dict[id] = Profile.new(cat, sou, both)


class Profile extends Object:
	var match_both: bool
	var categories: PoolStringArray
	var sources: PoolStringArray
	
	func _init(cat: PoolStringArray, sou: PoolStringArray, both: bool) -> void:
		categories = cat
		sources = sou
		match_both = both
	
	
	func append_category(cat: String) -> void:
		categories.append(cat)
	
	
	func append_source(sou: String) -> void:
		sources.append(sou)

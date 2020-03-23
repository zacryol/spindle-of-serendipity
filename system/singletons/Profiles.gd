extends Node

var profiles_dict: Dictionary # string for key, Profile object as value

func _ready() -> void:
	pass


func save_profile(id: String,
		cat: PoolStringArray, sou: PoolStringArray, both: bool) -> void:
	if profiles_dict.has(id):
		profiles_dict[id].free()
		profiles_dict.erase(id)
	profiles_dict[id] = Profile.new(cat, sou, both)
	pass


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

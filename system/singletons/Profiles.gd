extends Node

var profiles_dict: Dictionary # string for key, Profile object as value

func _ready():
	pass


class Profile extends Object:
	var match_both: bool
	var categories: PoolStringArray
	var sources: PoolStringArray
	
	func _init(cat: PoolStringArray, sou: PoolStringArray, both: bool):
		categories = cat
		sources = sou
		match_both = both
	
	func append_category(cat: String):
		categories.append(cat)
	
	
	func append_source(sou: String):
		sources.append(sou)

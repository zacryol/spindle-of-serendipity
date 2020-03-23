extends Node

var profiles_dict: Dictionary # string for key, Profile object as value

func _ready():
	pass


class Profile:
	var categories: PoolStringArray
	var sources: PoolStringArray
	
	func append_category(cat: String):
		categories.append(cat)
	
	
	func append_source(sou: String):
		sources.append(sou)

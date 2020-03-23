extends Node

var profiles_dict: Dictionary # string for key, Profile object as value

func _ready():
	pass


class Profile:
	var categories: PoolStringArray
	var sources: PoolStringArray

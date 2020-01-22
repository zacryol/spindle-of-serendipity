extends Object
class_name Entry

var text : String
var category : String
var source : String

func _init(new_text : String, new_category := GlobalVars.DEFAULT_CATEGORY, new_source := GlobalVars.DEFAULT_SOURCE):
	text = new_text
	category = new_category
	source = new_source

func get_entry_text() -> String:
	return text

func get_import_category() -> String:
	return category

func get_import_source() -> String:
	return source

func get_game_category() -> String:
	# For Aliases Later
	return get_import_category()

func get_game_source() -> String:
	# For Aliases Later
	return get_import_source()

func _to_string():
	return "Text: " + text + ", Category: " + category + ", Source: " + source

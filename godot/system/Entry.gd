class_name Entry
extends Reference

var archive: String = ""
var text: String
var category: String = GlobalVars.DEFAULT_CATEGORY
var source: String = GlobalVars.DEFAULT_SOURCE

var picked := false

func _init(file: String, 
		new_text: String,
		new_category := "",
		new_source := ""):
	archive = file
	text = new_text
	if new_category:
		category = new_category
	if new_source:
		source = new_source


func get_entry_text() -> String:
	return text


func get_import_category() -> String:
	return category


func get_import_source() -> String:
	return source


func get_game_category() -> String:
	return Alias.category(category)


func get_game_source() -> String:
	return Alias.source(source)


func _to_string() -> String:
	return "Text: " + text + ", Category: " + category + ", Source: " + source

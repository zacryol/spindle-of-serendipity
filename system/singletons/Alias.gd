extends Node

var aliases_cat : Dictionary
var aliases_sou : Dictionary

func _ready():
	load_from_file()


func has(import : String, is_cat : bool) -> bool:
	if is_cat:
		return aliases_cat.has(import)
	else:
		return aliases_sou.has(import)


func add_category(old : String, new : String):
	aliases_cat[old] = new
	save_to_file()


func add_source(old : String, new : String):
	aliases_sou[old] = new
	save_to_file()


func erase_cat(old : String):
	aliases_cat.erase(old)


func erase_sou(old : String):
	aliases_sou.erase(old)


func category(import: String) -> String:
	if aliases_cat.has(import.to_lower()):
		return aliases_cat[import.to_lower()]
	else:
		return import


func source(import: String) -> String:
	if aliases_sou.has(import.to_lower()):
		return aliases_sou[import.to_lower()]
	else:
		return import


func load_from_file():
	var f := File.new()
	if f.file_exists(GlobalVars.ALIAS_SAVE):
		f.open(GlobalVars.ALIAS_SAVE, File.READ)
		var s := f.get_as_text()
		var v = validate_json(s)
		if not v:
			var a = parse_json(s)
			if typeof(a) == TYPE_DICTIONARY:
				var d := a as Dictionary
				if d.has("cat"):
					aliases_cat = d["cat"]
				if d.has("sou"):
					aliases_sou = d["sou"]
	f.close()


func save_to_file():
	var save_dict := {
		"cat" : aliases_cat,
		"sou" : aliases_sou
	}
	var f := File.new()
	f.open(GlobalVars.ALIAS_SAVE, File.WRITE)
	f.store_string(to_json(save_dict))
	f.close()

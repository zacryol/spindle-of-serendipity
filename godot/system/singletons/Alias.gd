extends Node

var aliases_cat: Dictionary
var aliases_sou: Dictionary

func _ready():
	load_from_file()


func has(import: String, is_cat: bool) -> bool:
	if is_cat:
		return aliases_cat.has(import)
	else:
		return aliases_sou.has(import)


func add_category(old: String, new: String):
	aliases_cat[old] = new
	save_to_file()


func add_source(old: String, new: String):
	aliases_sou[old] = new
	save_to_file()


func erase_cat(old: String):
	aliases_cat.erase(old)
	save_to_file()


func erase_sou(old: String):
	aliases_sou.erase(old)
	save_to_file()


func category(import: String) -> String:
	if aliases_cat.has(import):
		return aliases_cat[import]
	else:
		return import


func source(import: String) -> String:
	if aliases_sou.has(import):
		return aliases_sou[import]
	else:
		return import


func load_from_file():
	var f := File.new()
	if f.file_exists(GlobalVars.ALIAS_SAVE):
		var err := f.open(GlobalVars.ALIAS_SAVE, File.READ)
		if err:
			return
		var s = f.get_var()
		if typeof(s) == TYPE_DICTIONARY:
			if s.has("cat"):
				aliases_cat = s["cat"]
			if s.has("sou"):
				aliases_sou = s["sou"]
		f.close()


func save_to_file():
	var save_dict := {
		"cat" : aliases_cat,
		"sou" : aliases_sou,
	}
	var f := File.new()
	var err := f.open(GlobalVars.ALIAS_SAVE, File.WRITE)
	if err:
		return
	f.store_var(save_dict)
	f.close()

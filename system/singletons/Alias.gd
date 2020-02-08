extends Node

var aliases_cat : Dictionary
var aliases_sou : Dictionary

func _ready():
	pass


func load_from_file():
	var f := File.new()
	if f.file_exists(GlobalVars.ALIAS_SAVE):
		f.open(GlobalVars.ALIAS_SAVE, File.WRITE)
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

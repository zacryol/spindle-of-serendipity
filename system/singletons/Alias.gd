extends Node

var aliases : Dictionary

func _ready():
	pass


func load_from_file():
	var f := File.new()
	if not f.file_exists(GlobalVars.ALIAS_SAVE):
		return
	f.open(GlobalVars.ALIAS_SAVE, File.READ)
	var s := f.get_as_text()
	var v := validate_json(s)
	if not v:
		var a = parse_json(s)
		if typeof(a) == TYPE_DICTIONARY:
			aliases = a


func save_to_file():
	var f := File.new()
	f.open(GlobalVars.ALIAS_SAVE, File.WRITE)
	if not aliases.empty():
		f.store_string(to_json(aliases))

extends Node

func import_entries_from_file(path : String):
	var f := File.new()
	f.open(path, File.READ)
	while f.eof_reached() == false:
		var line = parse_json(f.get_line())
		print(line)
		pass
	pass

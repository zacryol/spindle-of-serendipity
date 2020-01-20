extends Node


func import_entries_from_file(path : String):
	var f := File.new()
	f.open(path, File.READ)
	while not f.eof_reached():
		var j = parse_json(f.get_line())
		if typeof(j) == 19:
			var data = PoolStringArray(j)
			EntryManager.add_entry(data)
	pass

func grab_files():
	var path = GlobalVars.ENTRIES_SAVE
	var d = Directory.new()
	if d.dir_exists(path) == false:
		d.make_dir_recursive(path)
	d.open(path)
	d.list_dir_begin(true, true)
	while true:
		var f = d.get_next()
		print(f)
		if f == "":
			break
		import_entries_from_file(path + f)
	
	pass

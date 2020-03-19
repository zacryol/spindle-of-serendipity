extends Node

func _ready():
	grab_saved_files()


func import_entries_from_file(path : String):
	var f := File.new()
	var err := f.open(path, File.READ)
	if err:
		return
	while not f.eof_reached():
		var line := f.get_line()
		var v := validate_json(line)
		if not v:
			var j = parse_json(line)
			if typeof(j) == TYPE_ARRAY:
				var data := PoolStringArray(j)
				EntryManager.add_entry(data)
		elif line:
			print("ERROR: Entry \"" + line + "\" in file " +
					path.get_file() + " is invalid")


func grab_saved_files():
	var path := GlobalVars.ENTRIES_SAVE
	var d := Directory.new()
	if d.dir_exists(path) == false:
		d.make_dir_recursive(path)
	d.open(path)
	d.list_dir_begin(true, true)
	while true:
		var f := d.get_next()
		if f == "":
			break
		import_entries_from_file(path + f)

extends Node

func _ready() -> void:
	grab_saved_files()


func reimport() -> void:
	EntryManager.clear()
	grab_saved_files()


func import_entries_from_file(path: String) -> void:
	var f := File.new()
	var a := path.get_file()
	var err := f.open(path, File.READ)
	if err:
		return
	while not f.eof_reached():
		var line := f.get_line()
		var v := validate_json(line)
		if v:
			if line:
				print("ERROR: Entry \"" + line + "\" in file " + a + " is invalid")
			continue
		
		var j = parse_json(line)
		if typeof(j) == TYPE_ARRAY:
			var data := PoolStringArray(j)
			EntryManager.add_entry(a.get_basename(), data)
		
	f.close()


func grab_saved_files() -> void:
	var path := GlobalVars.ENTRIES_SAVE
	var d := Directory.new()
	if d.dir_exists(path) == false:
		d.make_dir_recursive(path)
	var err := d.open(path)
	if err:
		return
	d.list_dir_begin(true, true)
	while true:
		var f := d.get_next()
		if f == "":
			break
		import_entries_from_file(path + f)

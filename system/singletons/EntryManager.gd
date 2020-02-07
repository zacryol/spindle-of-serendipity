extends Node

var entries : Array # Only add Entry objects

func add_entry(data : PoolStringArray):
	if data.size() == 1:
		entries.append(Entry.new(data[0]))
	elif data.size() == 2:
		entries.append(Entry.new(data[0], data[1]))
	elif data.size() >= 3:
		entries.append(Entry.new(data[0], data[1], data[2]))


func _to_string() -> String:
	var out := ""
	for entry in entries:
		out = out + entry.to_string() + '\n'
	return out


func get_random_entry() -> Entry:
	match GlobalVars.rand_mode:
		GlobalVars.RAND_CAT:
			pass
		GlobalVars.RAND_SOU:
			pass
	var index := randi() % entries.size()
	return entries[index]


func get_categories() -> PoolStringArray:
	var cat : PoolStringArray
	for e in entries:
		if e is Entry:
			if not e.get_game_category().to_lower() in cat:
				cat.append(e.get_game_category().to_lower())
	return cat


func get_sources() -> PoolStringArray:
	var sou : PoolStringArray
	for e in entries:
		if e is Entry:
			if not e.get_game_source().to_lower() in sou:
				sou.append(e.get_game_source().to_lower())
	return sou

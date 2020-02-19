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
			return randomize_by_category()
		GlobalVars.RAND_SOU:
			return randomize_by_source()
	var index := randi() % entries.size()
	return entries[index]


func randomize_by_category() -> Entry:
	var cats := get_categories()
	var cat := cats[randi() % cats.size()]
	var es := get_entries_in_category(cat)
	return es[randi() % es.size()]


func randomize_by_source() -> Entry:
	var sous := get_sources()
	var sou := sous[randi() % sous.size()]
	var es := get_entries_in_source(sou)
	return es[randi() % es.size()]


func get_categories() -> PoolStringArray:
	var cat : PoolStringArray = []
	for e in entries:
		if e is Entry:
			if not e.get_game_category().to_lower() in cat:
				cat.append(e.get_game_category().to_lower())
	return cat


func get_sources() -> PoolStringArray:
	var sou : PoolStringArray = []
	for e in entries:
		if e is Entry:
			if not e.get_game_source().to_lower() in sou:
				sou.append(e.get_game_source().to_lower())
	return sou


func get_entries_in_category(category : String) -> Array:
	var cat = category.to_lower()
	var es : Array = []
	for e in entries:
		if e is Entry:
			if e.get_game_category().to_lower() == cat:
				es.append(e)
	return es


func get_entries_in_source(source : String) -> Array:
	var sou := source.to_lower()
	var es : Array = []
	for e in entries:
		if e is Entry:
			if e.get_game_source().to_lower() == sou:
				es.append(e)
	return es


func get_import_categories() -> PoolStringArray:
	var categories : PoolStringArray = []
	for e in entries:
		if e is Entry:
			if not e.get_import_category().to_lower() in categories:
				categories.append(e.get_import_category().to_lower())
	return categories


func get_import_sources() -> PoolStringArray:
	var sources : PoolStringArray = []
	for e in entries:
		if e is Entry:
			if not e.get_import_source().to_lower() in sources:
				sources.append(e.get_import_source().to_lower())
	return sources

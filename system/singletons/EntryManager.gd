extends Node

var entries: Array # Only add Entry objects

func _to_string() -> String:
	var out := ""
	for entry in entries:
		out = out + entry.to_string() + '\n'
	return out


func add_entry(data: PoolStringArray):
	var e: Entry
	if data.size() == 1:
		e = Entry.new(data[0])
	elif data.size() == 2:
		e = Entry.new(data[0], data[1])
	elif data.size() >= 3:
		e = Entry.new(data[0], data[1], data[2])
	
	if not contains_equivalent(e):
		entries.append(e)
	else:
		print("Entry: \"" + e.to_string() + "\" already present")


func contains_equivalent(e: Entry) -> bool:
	for entry in entries:
		if entry.to_string() == e.to_string():
			return true
	return false


func reset_picked() -> void:
	for e in entries:
		(e as Entry).picked = false


func pick(e: Entry) -> Entry:
	e.picked = true
	return e


func get_unpicked_entries() -> Array:
	var unpicked := []
	for e in entries:
		if not e.picked:
			unpicked.append(e)
	return unpicked


func get_random_entry() -> Entry:
	if get_unpicked_entries().size() < GlobalVars.refresh_entries_at:
		reset_picked()
	
	match GlobalVars.rand_mode:
		GlobalVars.RAND_CAT:
			return pick(randomize_by_category())
		GlobalVars.RAND_SOU:
			return pick(randomize_by_source())
	var es := get_unpicked_entries()
	return pick(es[randi() % es.size()])


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


func get_categories(all := false) -> PoolStringArray:
	var cat: PoolStringArray = []
	var es: Array = entries if all else get_unpicked_entries()
	for e in es:
		if e is Entry:
			if not e.get_game_category().to_lower() in cat:
				cat.append(e.get_game_category().to_lower())
	return cat


func get_sources(all := false) -> PoolStringArray:
	var sou: PoolStringArray = []
	var es: Array = entries if all else get_unpicked_entries()
	for e in es:
		if e is Entry:
			if not e.get_game_source().to_lower() in sou:
				sou.append(e.get_game_source().to_lower())
	return sou


func get_entries_in_category(category: String) -> Array:
	var cat := category.to_lower()
	var es: Array = []
	for e in get_unpicked_entries():
		if e is Entry:
			if e.get_game_category().to_lower() == cat:
				es.append(e)
	return es


func get_entries_in_source(source: String) -> Array:
	var sou := source.to_lower()
	var es: Array = []
	for e in get_unpicked_entries():
		if e is Entry:
			if e.get_game_source().to_lower() == sou:
				es.append(e)
	return es


func get_import_categories() -> PoolStringArray:
	var categories: PoolStringArray = []
	for e in entries:
		if e is Entry:
			if not e.get_import_category().to_lower() in categories:
				categories.append(e.get_import_category().to_lower())
	return categories


func get_import_sources() -> PoolStringArray:
	var sources: PoolStringArray = []
	for e in entries:
		if e is Entry:
			if not e.get_import_source().to_lower() in sources:
				sources.append(e.get_import_source().to_lower())
	return sources

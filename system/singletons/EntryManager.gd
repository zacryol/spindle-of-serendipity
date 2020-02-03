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
	var index := randi() % entries.size()
	return entries[index]

extends Container

const Y_CHANGE := 51
const X_OFFSET := 29.5

var HexType := preload("res://hex_panel/HexNode.gd")

export var text: String setget set_text

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		rect_min_size = Vector2(0, 0)
		var count := 0
		for c in get_children():
			if not c is HexRow:
				continue
			
			c = c as HexRow
			c.rect_position = Vector2(X_OFFSET * (count % 2), Y_CHANGE * count)
			rect_min_size.x = max(rect_min_size.x, c.rect_size.x + X_OFFSET * (count % 2))
			rect_min_size.y = max(rect_min_size.y, c.rect_size.y + Y_CHANGE * count)
			count += 1
		# sort
		pass


func split_lines(lines: String) -> PoolStringArray:
	return $StringParser.parse(lines)


func set_text(new_text: String):
	text = new_text
	
	while get_child_count() > 1:
		remove_child(get_child(1))
	
	for s in split_lines(new_text):
		var h := HexRow.new()
		add_child(h)
		h.line_text = s


func get_hex_nodes() -> Array:
	var nodes := []
	for i in range(1, get_child_count()):
		nodes += get_child(i).get_children()
	return nodes


func reveal_letter(letter: String) -> int:
	var count := 0
	letter = letter.substr(0, 1)
	for c in get_hex_nodes():
		if CharSet.compare(c.text, letter):
			c.current_state = HexType.State.REVEALED
			count += 1
	return count


func add_solve(letter: String):
	for c in get_hex_nodes():
		if c.current_state == HexType.State.BLOCKED:
			c.temp(letter)
			return


func clear_solve():
#	for i in range(1, get_child_count()):
#		get_child(i).clear_solve()
	for c in get_hex_nodes():
		if c.current_state == HexType.State.TEMP:
			c.current_state = HexType.State.BLOCKED


func pop_solve() -> void:
	var i := get_child_count() - 1
	while i > 0:
		if get_child(i).pop_solve():
			return
		i -= 1


func verify() -> bool:
	for c in get_children():
		if not c is HexRow:
			continue
		else:
			if not c.verify():
				return false
	return true


func reveal_all():
	for i in range(1, get_child_count()):
		get_child(i).reveal_all()
	pass

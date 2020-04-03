extends Container

const Y_CHANGE := 51
const X_OFFSET := 29.5

export var text: String setget set_text

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		var count := 0
		for c in get_children():
			if not c is HexRow:
				continue
			
			c = c as HexRow
			c.rect_position = Vector2(X_OFFSET * (count % 2), Y_CHANGE * count)
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
		h.line_text = s
		add_child(h)


func reveal_letter(letter: String):
	letter = letter.substr(0, 1)
	for i in range(1, get_child_count()):
		get_child(i).reveal_letter(letter)
	pass


func add_solve(stack: PoolStringArray):
	clear_solve()
	var index := 0
	for i in range(1, get_child_count()):
		index += get_child(i).add_solve(stack, index)
		pass
	pass


func clear_solve():
	for i in range(1, get_child_count()):
		get_child(i).clear_solve()
	pass

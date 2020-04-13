class_name HexRow
extends HBoxContainer

export var line_text: String setget set_line, get_line

var hex_node: PackedScene = preload("res://hex_panel/HexNode.tscn")
var HexType := preload("res://hex_panel/HexNode.gd")

func set_line(text: String):
	line_text = text
	var length := text.length()
	var i := 0
	while i < length and i < get_child_count():
		var c = get_child(i)
		if not c is HexType:
			remove_child(c)
			c.queue_free()
		else:
			c.text = text.substr(i, 1)
			i += 1
	
	if i >= get_child_count():
		while i < text.length():
			add_letter(text.substr(i, 1))
			i += 1
		# add extra
		pass
	
	if i >= length:
		while i < get_child_count():
			var c = get_child(i)
			remove_child(c)
			c.queue_free()
		# remove remaining children
		pass


func get_line() -> String:
	return line_text


func add_letter(letter: String) -> void:
	var l = hex_node.instance()
	add_child(l)
	l.text = letter.substr(0, 1)


func reveal_letter(letter: String) -> int:
	var count := 0
	for c in get_children():
		if CharSet.compare(c.text, letter):
			c.current_state = HexType.State.REVEALED
			count += 1
	return count


func add_solve(letter: String) -> bool:
	for c in get_children():
		if c.current_state == HexType.State.BLOCKED:
			c.temp(letter)
			return true
		pass
	return false


func clear_solve():
	for c in get_children():
		if c.current_state == HexType.State.TEMP:
			c.current_state = HexType.State.BLOCKED
	pass


func pop_solve() -> bool:
	var i := get_child_count() - 1
	while i >= 0:
		if get_child(i).current_state == HexType.State.TEMP:
			get_child(i).current_state = HexType.State.BLOCKED
			return true
		i -= 1
	return false


func verify() -> bool:
	for c in get_children():
		if not c.verify():
			return false
	return true


func reveal_all():
	for c in get_children():
		c.current_state = HexType.State.REVEALED

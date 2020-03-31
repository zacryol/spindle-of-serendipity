tool
extends HBoxContainer

export var line_text: String setget set_line, get_line

var hex_node: PackedScene = preload("res://hex_panel/HexNode.tscn")

func _ready():
	pass


func set_line(text: String):
	var length := text.length()
	var i := 0
	while i < length and i < get_child_count():
		var c = get_child(i)
		if not c is HexNode:
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
	
	print(text.length())
#	print(get_child_count())


func get_line() -> String:
	return line_text


func add_letter(letter: String) -> void:
	var l: HexNode = hex_node.instance()
	l.text = letter.substr(0, 1)
	l.current_state = HexNode.State.REVEALED
	add_child(l)

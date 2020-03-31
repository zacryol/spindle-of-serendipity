tool
extends HBoxContainer

export var line_text: String setget set_line, get_line

var HexNode: PackedScene = preload("res://hex_panel/HexNode.tscn")

func _ready():
	pass


func set_line(text: String):
	var length := text.length()
	var i := 0
	while i < length and i < get_child_count():
		var c = get_child(i)
		if not c is Label:
			remove_child(c)
			c.queue_free()
		else:
			c.text = text.substr(i, 1)
			i += 1
	
	if i >= get_child_count():
		# add extra
		pass
	
	if i >= length:
		# remove remaining children
		pass
	
	print(text.length())
#	print(get_child_count())


func get_line() -> String:
	return line_text


func add_letter(letter: String) -> void:
	var l := Label.new()
	l.text = letter.substr(0, 1)
	add_child(l)

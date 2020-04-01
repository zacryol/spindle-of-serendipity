extends Container

export var text: String setget set_text

func _ready():
	pass


func split_lines(lines: String) -> PoolStringArray:
	return $StringParser.parse(lines)


func set_text(new_text: String):
	text = new_text
	for s in split_lines(new_text):
		var h := HexRow.new()
		h.line_text = s
		add_child(h)
	print(split_lines(new_text).size())
	pass

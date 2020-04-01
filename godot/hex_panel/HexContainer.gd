extends Container

export var text: String setget set_text

func _ready():
	pass


func split_lines(lines: String) -> PoolStringArray:
	return $StringParser.parse(lines)


func set_text(new_text: String):
	pass

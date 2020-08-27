extends Panel

var value: int = 5 setget set_value

func _ready():
	pass


func set_value(new_value) -> void:
	value = new_value
	$Label.text = str(new_value)
	if new_value < 0:
		$Label.modulate = Color.red
	else:
		$Label.modulate = Color.white
	pass

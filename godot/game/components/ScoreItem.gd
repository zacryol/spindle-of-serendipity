extends Panel

var value: int = 5 setget set_value


func set_value(new_value) -> void:
	value = new_value
	$Label.text = str(new_value)
	if new_value < 0:
		$Label.modulate = Color.red
	elif new_value >= 50:
		$Label.modulate = Color.yellow
	else:
		$Label.modulate = Color.white

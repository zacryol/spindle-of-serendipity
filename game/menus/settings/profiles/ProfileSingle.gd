extends PanelContainer


func _ready():
	pass


func set_text(new_text: String):
	$HBoxContainer/Label.text = new_text

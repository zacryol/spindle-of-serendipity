extends CanvasLayer

var message := "Round %s"
var suffix := " of %s"

onready var label: Label = $Main/PanelContainer/Label

func _ready():
	pass


func new_round(num: int) -> void:
	var show := message % str(num)
	if GlobalVars.game_type == GlobalVars.Type.ROUNDS:
		show += suffix % str(GlobalVars.rounds)
	label.text = show
	$AnimationPlayer.play("In")


func _on_EntryDisplay_text_ready():
	$AnimationPlayer.play("Out")
	pass # Replace with function body.

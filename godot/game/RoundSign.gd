extends CanvasLayer

var message := "Round %s"
var suffix := " of %s"

onready var label: Label = $Main/PanelContainer/Label

func _ready():
	pass


func new_round(num: int) -> void:
	var show := message % str(num)
	if GlobalVars.game_type == GlobalVars.Type.ROUNDS:
		if GlobalVars.rounds == num:
			show = "Final Round"
			label.modulate = Color(1, 0, 0, 1)
		else:
			show += suffix % str(GlobalVars.rounds)
	label.text = show
	$AnimationPlayer.play("In")
	$Timer.start()


func _on_EntryDisplay_text_ready():
	if $Timer.time_left:
		yield($Timer, "timeout")
	
	$AnimationPlayer.play("Out")

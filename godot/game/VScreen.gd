extends CanvasLayer

onready var place_labels = [
	$Main/Place1/Label,
	$Main/Place2/Label,
	$Main/Place3/Label,
]

func _ready():
	pass


func show():
	$Main.show()


# Array of dictionaries returned from PlayersPanel.get_final_results()
func set_results(res: Array):
	var disp: String = "%s : %s points"
	for i in place_labels.size():
			place_labels[i].text = disp % [res[i]["name"], res[i]["score"]]
			pass
	pass

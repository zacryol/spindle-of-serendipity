extends Control

onready var score_items := $VBoxContainer.get_children()
# The one the Spindle points at
onready var center_item := $VBoxContainer/ScoreItem4

var scores: Array = [
	-15,
	-5,
	10,
	15,
	20,
	25,
	25,
	30,
	35,
	40,
	45,
	50,
]

func _ready():
	scores.shuffle()
	scores.append(-25)
	scores.append(85)
	scores.append(-25)
	set_values()


func set_values():
	assert(score_items.size() <= scores.size())
	
	for i in score_items.size():
		score_items[i].value = scores[i]
		pass
	


func start():
	$Timer.start()


func stop():
	$Timer.stop()
	return center_item.value


func tick():
	var shift = scores.pop_back()
	scores.push_front(shift)
	set_values()


func _on_Timer_timeout():
	tick()

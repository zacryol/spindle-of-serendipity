extends Control

onready var score_items := $VBoxContainer.get_children()
# The one the Spindle points at
onready var center_item := $VBoxContainer/ScoreItem4

var scores: Array = [
	-5,
	10,
	15,
	20,
	25,
	30,
	35,
	40,
	45,
	50,
]

func _ready():
	scores.shuffle()
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


func tick():
	var shift = scores.pop_back()
	scores.push_front(shift)
	set_values()


func _on_Timer_timeout():
	tick()

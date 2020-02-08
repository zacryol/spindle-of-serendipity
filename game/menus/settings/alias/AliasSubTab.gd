extends Tabs

onready var imports := $H/Import/VBox
onready var outs := $H/View/VBox

var is_categories : bool

func _ready():
	pass

func set_ui(cat : bool):
	is_categories = cat
	pass

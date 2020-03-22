extends ScrollContainer

onready var categories := $VBoxContainer/Config/Categories/List
onready var sources := $VBoxContainer/Config/Sources/List

func _ready():
	for cat in EntryManager.get_import_categories():
		var l := Label.new()
		l.text = cat
		categories.add_child(l)
	
	for sou in EntryManager.get_import_sources():
		var l := Label.new()
		l.text = sou
		sources.add_child(l)
	pass

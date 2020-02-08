extends Tabs

onready var imports := $H/Import/VBox
onready var outs := $H/View/VBox

var is_categories : bool
var import_values : PoolStringArray

var single = preload("res://game/menus/settings/alias/SingleAlias.tscn")

func set_ui(cat : bool):
	is_categories = cat
	initialize_imports()


func initialize_imports():
	if is_categories:
		import_values = EntryManager.get_import_categories()
	else:
		import_values = EntryManager.get_import_sources()
	
	for i in import_values:
		var s = single.instance()
		s.set_text(i, is_categories)
		s.connect("set_alias", self, "alias_set")
		s.connect("clear_alias", self, "alias_cleared")
		imports.add_child(s)


func alias_set(old : String, new : String):
	print(old + " to " + new)
	pass


func alias_cleared(old : String):
	print(old)
	pass

extends Tabs

var is_categories: bool
var import_values: PoolStringArray
var single := preload("res://game/menus/settings/alias/SingleAlias.tscn")

onready var imports := $H/Import/VBox
onready var outs := $H/View/VBox

func set_ui(cat: bool):
	is_categories = cat
	initialize_imports()
	update_game_list()


func update_game_list():
	for node in outs.get_children():
		node.queue_free()
	
	var out : PoolStringArray
	if is_categories:
		out = EntryManager.get_categories(true)
	else:
		out = EntryManager.get_sources(true)
	
	for o in out:
		var l = Label.new()
		l.text = o
		outs.add_child(l)


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
	if is_categories:
		Alias.add_category(old, new)
	else:
		Alias.add_source(old, new)
	update_game_list()


func alias_cleared(old : String):
	if is_categories:
		Alias.erase_cat(old)
	else:
		Alias.erase_sou(old)
	update_game_list()

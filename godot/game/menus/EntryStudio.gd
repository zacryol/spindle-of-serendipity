extends Control

var single := preload("res://game/menus/ESSingle.tscn")

onready var vbox := $PC/VBox/Main/Scroll/VBox as VBoxContainer
onready var scroll := $PC/VBox/Main/Scroll as ScrollContainer
onready var add_button := $PC/VBox/Main/Scroll/VBox/AddButton as Button
onready var save_name := $PC/VBox/Control2/SaveBit/LineEdit as LineEdit
onready var save_button := $PC/VBox/Control2/SaveBit/SaveButton as Button
onready var save_confirm := $AcceptDialog as AcceptDialog

func _ready() -> void:
	add_item()
	save_confirm.add_button("Overwrite", true, "over")
	save_confirm.add_button("Append", true, "add")
	save_confirm.get_ok().text = "Cancel"
	save_confirm.connect("confirmed", self, "_on_AcceptDialog_custom_action", [""])


func add_item() -> void:
	var s := single.instance()
	vbox.add_child(s)
	vbox.move_child(add_button, vbox.get_child_count() - 1)
	add_button.release_focus()
	yield(get_tree(), "idle_frame")
	scroll.get_v_scrollbar().ratio = 1


func _on_FolderButton_pressed() -> void:
	OS.shell_open(OS.get_user_data_dir() + "/entries")


func _on_AddButton_pressed() -> void:
	add_item()


func _on_MenuButton_pressed() -> void:
	get_tree().change_scene("res://game/menus/MainMenu.tscn")


func _on_SaveButton_pressed() -> void:
	var path := save_name.text
	if path.get_extension().to_lower() != "json":
		path += ".json"
	
	var f = File.new()
	if f.file_exists(GlobalVars.ENTRIES_SAVE + path):
		# check with user - overwrite?
		save_button.disabled = true
		save_confirm.dialog_text = "File %s already exists" % (GlobalVars.ENTRIES_SAVE + path)
		save_confirm.show()
		return
	
	# goes into other function after confirming action
	var lines_array := []
	for line in vbox.get_children():
		if line is Button:
			continue
		
		assert(line is PanelContainer)
		var e := []
		e.append(line.get_text())
		e.append(line.get_category())
		e.append(line.get_source())
		lines_array.append(e)
	print(lines_array)
	# write file
		# to_json() each line, store line
	# EntryImport reimport()


func _on_AcceptDialog_custom_action(action: String) -> void:
	print(action)


func _on_AcceptDialog_hide() -> void:
	save_button.disabled = false

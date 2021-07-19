###############################################################################
# spindle of serendipity                                                      #
# Copyright (C) 2020-2021 zacryol (https://gitlab.com/zacryol)                #
#-----------------------------------------------------------------------------#
# This file is part of spindle of serendipity.                                #
#                                                                             #
# spindle of serendipity is free software: you can redistribute it and/or     #
# modify it under the terms of the GNU General Public License as published by #
# the Free Software Foundation, either version 3 of the License, or           #
# (at your option) any later version.                                         #
#                                                                             #
# spindle of serendipity is distributed in the hope that it will be useful,   #
# but WITHOUT ANY WARRANTY; without even the implied warranty of              #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               #
# GNU General Public License for more details.                                #
#                                                                             #
# You should have received a copy of the GNU General Public License           #
# along with spindle of serendipity.                                          #
# If not, see <http://www.gnu.org/licenses/>.                                 #
###############################################################################

extends Control

var single := preload("res://game/menus/ESSingle.tscn")

onready var vbox := $PC/VBox/Main/Scroll/VBox as VBoxContainer
onready var scroll := $PC/VBox/Main/Scroll as ScrollContainer
onready var add_button := $PC/VBox/Main/Scroll/VBox/AddButton as Button
onready var save_name := $PC/VBox/Control2/SaveBit/LineEdit as LineEdit
onready var save_button := $PC/VBox/Control2/SaveBit/SaveButton as Button
onready var save_confirm := $AcceptDialog as AcceptDialog
onready var load_dialog := $FileDialog as FileDialog
onready var go_to_main := $MainConfirm as ConfirmationDialog
onready var saved_label := $PC/VBox/Control2/SaveBit/Saved as Label
onready var saved_tween := $PC/VBox/Control2/SaveBit/Saved/Tween as Tween

func _ready() -> void:
	MusicManager.play_song_id("side")
	add_item()
	save_confirm.add_button("Overwrite", true, "over")
	save_confirm.add_button("Append", true, "add")
	save_confirm.get_ok().text = "Cancel"
	save_confirm.connect("confirmed", self, "_on_AcceptDialog_custom_action", [""])


func add_item() -> Node:
	var s := single.instance()
	vbox.add_child(s)
	add_button.raise()
	add_button.release_focus()
	yield(get_tree(), "idle_frame")
	scroll.get_v_scrollbar().ratio = 1
	s.connect("move_request", self, "_on_ESSingle_move_request", [s])
	return s


func save_entries_to_file(f: File) -> void:
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
	
	for line in lines_array:
		var e := to_json(line)
		f.store_line(e)
	var path := f.get_path().get_file().get_basename()
	f.close()
	EntryImport.reimport(path)
	show_fade_label()


func show_fade_label() -> void:
	saved_tween.interpolate_property(saved_label, "self_modulate:a", 1, 0, 1.0)
	saved_tween.start()


func _on_FolderButton_pressed() -> void:
	OS.shell_open(OS.get_user_data_dir() + "/entries")


func _on_AddButton_pressed() -> void:
	add_item()


func _on_MenuButton_pressed() -> void:
	go_to_main.show()


func _on_SaveButton_pressed() -> void:
	var path := save_name.text
	if path.get_extension().to_lower() != "json":
		path += ".json"
	
	var f := File.new()
	if f.file_exists(GlobalVars.ENTRIES_SAVE + path):
		save_button.disabled = true
		save_confirm.dialog_text = """File %s already exists.
		(If saving to a file you loaded and edited, please select \"Overwrite\")"""\
		 % (GlobalVars.ENTRIES_SAVE + path)
		save_confirm.show()
		return
	
	f.open(GlobalVars.ENTRIES_SAVE + path, File.WRITE)
	save_entries_to_file(f)


func _on_AcceptDialog_custom_action(action: String) -> void:
	var path := save_name.text
	if path.get_extension().to_lower() != "json":
		path += ".json"
	var save_path := GlobalVars.ENTRIES_SAVE + path
	
	var f := File.new()
	match action:
		"over":
			f.open(save_path, File.WRITE)
		"add":
			f.open(save_path, File.READ_WRITE)
			f.seek_end()
		_:
			return
	
	save_entries_to_file(f)
	save_confirm.hide()


func _on_AcceptDialog_hide() -> void:
	save_button.disabled = false


func _on_LoadButton_pressed() -> void:
	load_dialog.show()
	load_dialog.current_path = GlobalVars.ENTRIES_SAVE
	load_dialog.current_dir = GlobalVars.ENTRIES_SAVE


func _on_FileDialog_file_selected(path: String) -> void:
	var f := File.new()
	f.open(path, File.READ)
	for line in vbox.get_children():
		if line is Button:
			continue
		
		line.queue_free()
	save_name.text = path.get_file().get_basename()
	while not f.eof_reached():
		var l := f.get_line()
		if not l and validate_json(l):
			continue
		var a = parse_json(l)
		if not typeof(a) == TYPE_ARRAY:
			continue
		var e := a as Array
		var s: Node = yield(add_item(), "completed")
		match e.size():
			0:
				continue
			1:
				s.set_values(e[0])
			2:
				s.set_values(e[0], e[1])
			_:
				s.set_values(e[0], e[1], e[2])


func _on_ESSingle_move_request(dir: int, item: Node) -> void:
	var target := item.get_index() + dir
	if target >= 0 and target < add_button.get_index():
		vbox.move_child(item, target)


func _on_MainConfirm_confirmed() -> void:
	get_tree().change_scene("res://game/menus/MainMenu.tscn")

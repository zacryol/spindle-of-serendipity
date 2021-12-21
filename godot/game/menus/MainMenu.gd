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

onready var tween := $Tween as Tween
onready var spindle := $SpindleTex as TextureRect
onready var buttons := $VBoxContainer as VBoxContainer
onready var files := $FileDialog as FileDialog

func _ready() -> void:
	$HexContainer.set_text("spindle of serendipity", not GlobalVars.menu_first_time)
	if GlobalVars.menu_first_time:
		var s_target := spindle.rect_position.x
		var b_target := buttons.rect_position.y
		buttons.rect_position.y += 700
		spindle.rect_position.x -= 1200
		tween.interpolate_property(spindle, "rect_position:x", null, s_target, 
				0.4, 0, Tween.EASE_OUT, 1.5)
		tween.interpolate_property(buttons, "rect_position:y", null, b_target, 
				0.4, Tween.TRANS_BOUNCE, 2, 1.5)
		tween.start()
		yield(get_tree().create_timer(1.8), "timeout")
		MusicManager.play_song_id("menu")
	else:
		MusicManager.play_song_id("menu")
	
	GlobalVars.menu_first_time = false


func _on_ImportButton_pressed() -> void:
	files.current_dir = OS.get_executable_path().get_base_dir()
	files.show()


func _on_FileDialog_files_selected(paths: PoolStringArray) -> void:
	for path in paths:
		EntryImport.import_entries_from_file(path)
		
		var file_name := str(path).get_file()
		var save_path := str(GlobalVars.ENTRIES_SAVE + file_name)
		if File.new().file_exists(save_path):
			var copy := 0
			var new_file_path: String
			var f := File.new()
			while f.file_exists(save_path):
				new_file_path = str(copy) + file_name
				save_path = str(GlobalVars.ENTRIES_SAVE + new_file_path)
				copy += 1
		Directory.new().copy(path, save_path)


func _on_StartButton_pressed() -> void:
	if EntryManager.entries.size() == 0:
		$AcceptDialog.show()
	else:
		get_tree().change_scene("res://game/GameSetting.tscn")


func _on_Settings_pressed() -> void:
	get_tree().change_scene("res://game/menus/settings/Settings.tscn")


func _on_EButton_pressed() -> void:
	get_tree().change_scene("res://game/menus/EntryStudio.tscn")


func _on_QuitButton_pressed() -> void:
	$QuitConfirm.show()


func _on_QuitConfirm_confirmed() -> void:
	get_tree().quit()

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

onready var legal_container := $PanelContainer/MarginContainer/TabContainer/Legal/VBoxContainer as VBoxContainer

func _ready() -> void:
	MusicManager.play_song_id("side")
	$PanelContainer/MarginContainer/TabContainer.current_tab = 1
	
	for node in legal_container.get_children():
		if node is RichTextLabel:
			var label := node as RichTextLabel
			label.connect("meta_clicked", self, "_meta_clicked")


func _on_Back_pressed() -> void:
	get_tree().change_scene("res://game/menus/MainMenu.tscn")


func _meta_clicked(meta: String) -> void:
	OS.shell_open(meta)

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

extends PanelContainer

signal move_request(direction)

onready var entry_enter := $HBoxContainer/E as LineEdit
onready var cat_enter := $HBoxContainer/C as LineEdit
onready var sou_enter := $HBoxContainer/S as LineEdit
onready var try_delete := $HBoxContainer/DeleteButton as Button
onready var del_conf := $HBoxContainer/DelConf as HBoxContainer
onready var up := $HBoxContainer/UpButton as Button
onready var down := $HBoxContainer/DownButton as Button

func get_text() -> String:
	return entry_enter.text


func get_category() -> String:
	return cat_enter.text


func get_source() -> String:
	return sou_enter.text


func set_values(e := "", c := "", s := "") -> void:
	entry_enter.text = e
	cat_enter.text = c
	sou_enter.text = s


func _on_DeleteButton_pressed() -> void:
	try_delete.hide()
	del_conf.show()


func _on_Yes_pressed() -> void:
	queue_free()


func _on_No_pressed() -> void:
	try_delete.show()
	del_conf.hide()


func _on_UpButton_pressed() -> void:
	emit_signal("move_request", -1)
	up.release_focus()


func _on_DownButton_pressed() -> void:
	emit_signal("move_request", 1)
	down.release_focus()

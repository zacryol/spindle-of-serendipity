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

extends "res://game/components/GameComponent.gd"

signal key_pressed(letter)
onready var key_container := $CenterContainer/GridContainer as GridContainer

func _ready() -> void:
	# Setup Keys
	key_container.columns = CharSet.get_row_length()
	
	var c := 0
	for l in CharSet.LINE_BREAKS:
		if l == key_container.columns:
			for i in key_container.columns:
				key_container.add_child(new_button(CharSet.CHAR_MAIN[c]))
				
				c += 1
		else:
			var n := 0
			while n < l:
				key_container.add_child(new_button(CharSet.CHAR_MAIN[c]))
				
				c += 1
				n += 1
			
			while n < key_container.columns:
				var b := Control.new()
				key_container.add_child(b)
				n += 1
	
	while c < CharSet.CHAR_MAIN.size():
		key_container.add_child(new_button(CharSet.CHAR_MAIN[c]))
		
		c += 1
	
	for key in get_keys():
		key.rect_min_size = Vector2(30, 31)
		key.connect("pressed", self, "_on_Key_pressed", [key.text])


func _input(event: InputEvent) -> void:
	if event is InputEventKey \
			&& not event.is_echo() \
			&& event.is_pressed():
		var e := char(event.unicode).to_upper()
		if e in CharSet.CHAR_MAIN:
			guess_letter(e)


func guess_letter(letter: String, suppress_repeat_log := false) -> void:
	emit_signal("key_pressed", letter, suppress_repeat_log)


func grab_focus() -> void:
	if Input.get_connected_joypads().size() == 0:
		return
	
	for b in get_keys():
		if not b.disabled:
			b.grab_focus()
			break


func get_keys() -> Array:
	var array := []
	for c in key_container.get_children():
		if c is Button:
			array.append(c)
	return array


func get_button(letter: String) -> Button:
	for key in key_container.get_children():
		if key is Button:
			if key.text == letter:
				return key
	return null


func enable() -> void:
	for key in key_container.get_children():
		if key is Button:
			key.disabled = false
			key.focus_mode = FOCUS_ALL


func new_button(text: String) -> Button:
	var b := Button.new()
	b.text = text
	b.add_to_group("key")
	return b


func _on_Key_pressed(letter: String) -> void:
	guess_letter(letter)


func _on_EntryDisplay_one_letter(letter) -> void:
	if get_button(letter):
		get_button(letter).disabled = true
		get_button(letter).focus_mode = FOCUS_NONE


func _on_Spindle_spun() -> void:
	grab_focus()

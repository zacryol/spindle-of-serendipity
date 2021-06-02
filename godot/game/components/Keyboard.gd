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
onready var key_container: GridContainer = $CenterContainer/GridContainer

func _ready():
	# Setup Keys
	key_container.columns = CharSet.get_row_length()
	
	var c := 0
	for l in CharSet.LINE_BREAKS:
		if l == key_container.columns:
			for i in key_container.columns:
				var b := Button.new()
				b.text = CharSet.CHAR_MAIN[c]
				key_container.add_child(b)
				
				c += 1
		else:
			var n := 0
			while n < l:
				var b := Button.new()
				b.text = CharSet.CHAR_MAIN[c]
				key_container.add_child(b)
				
				c += 1
				n += 1
			
			while n < key_container.columns:
				var b := Control.new()
				key_container.add_child(b)
				n += 1
	
	while c < CharSet.CHAR_MAIN.size():
		var b := Button.new()
		b.text = CharSet.CHAR_MAIN[c]
		key_container.add_child(b)
		
		c += 1
	
	var keys := key_container.get_children()
	for key in keys:
		if key is Button:
			key.rect_min_size = Vector2(30, 31)
			key.connect("pressed", self, "_on_Key_pressed", [key.text])


func _input(event):
	if event is InputEventKey \
			&& event.scancode in range(KEY_A, KEY_Z + 1) \
			&& not event.is_echo() \
			&& event.is_pressed():
		var e := str(event.as_text().right(event.as_text().length() - 1))
		guess_letter(e)


func guess_letter(letter: String):
	emit_signal("key_pressed", letter)


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


func _on_Key_pressed(letter: String) -> void:
	guess_letter(letter)


func _on_EntryDisplay_one_letter(letter) -> void:
	if get_button(letter):
		get_button(letter).disabled = true

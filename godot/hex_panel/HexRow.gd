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

class_name HexRow
extends HBoxContainer

const HexType := preload("res://hex_panel/HexNode.gd")

export var line_text: String setget set_line, get_line
var hex_node: PackedScene = preload("res://hex_panel/HexNode.tscn")


func set_line(text: String):
	line_text = text
	var length := text.length()
	var i := 0
	while i < length and i < get_child_count():
		var c := get_child(i)
		if not c is HexType:
			remove_child(c)
			c.queue_free()
		else:
			c.text = text.substr(i, 1)
			i += 1
	
	if i >= get_child_count():
		while i < text.length():
			add_letter(text.substr(i, 1))
			i += 1
		# add extra
		pass
	
	if i >= length:
		while i < get_child_count():
			var c := get_child(i)
			remove_child(c)
			c.queue_free()
		# remove remaining children
		pass


func get_line() -> String:
	return line_text


func add_letter(letter: String) -> void:
	var l := hex_node.instance()
	add_child(l)
	l.text = letter.substr(0, 1)

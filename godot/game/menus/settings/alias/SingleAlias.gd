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

extends HBoxContainer

signal set_alias(import, out)
signal clear_alias(old)

var text: String

func set_text(new_text: String, is_cat: bool):
	text = new_text
	$Import.text = new_text
	if Alias.has(new_text, is_cat):
		var out: String
		if is_cat:
			out = Alias.category(new_text)
		else:
			out = Alias.source(new_text)
		$Input.text = out
		pass


func _on_Add_pressed():
	if $Input.text != "":
		emit_signal("set_alias", text, $Input.text)


func _on_Clear_pressed():
	$Input.text = ""
	emit_signal("clear_alias", text)

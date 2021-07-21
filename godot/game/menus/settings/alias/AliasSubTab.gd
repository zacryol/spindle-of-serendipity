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

signal alias_created

var is_categories: bool
var import_values: PoolStringArray
var single := preload("res://game/menus/settings/alias/SingleAlias.tscn")

onready var imports := $H/Import/VBox
onready var outs := $H/View/VBox

func set_ui(cat: bool) -> void:
	is_categories = cat
	initialize_imports()
	update_game_list()


func update_game_list() -> void:
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


func initialize_imports() -> void:
	if is_categories:
		import_values = EntryManager.get_import_categories()
	else:
		import_values = EntryManager.get_import_sources()
	
	for i in import_values:
		var s := single.instance()
		s.connect("set_alias", self, "alias_set")
		s.connect("clear_alias", self, "alias_cleared")
		imports.add_child(s)
		s.set_text(i, is_categories)


func alias_set(old: String, new: String) -> void:
	if is_categories:
		Alias.add_category(old, new)
	else:
		Alias.add_source(old, new)
	update_game_list()
	emit_signal("alias_created")


func alias_cleared(old: String) -> void:
	if is_categories:
		Alias.erase_cat(old)
	else:
		Alias.erase_sou(old)
	update_game_list()
	emit_signal("alias_created")

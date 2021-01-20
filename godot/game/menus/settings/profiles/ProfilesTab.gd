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

var current_profile := ""
var single := preload("res://game/menus/settings/profiles/ProfileSingle.tscn")
onready var categories := $VBoxContainer/Config/Categories/SC/List
onready var sources := $VBoxContainer/Config/Sources/SC/List
onready var archives := $VBoxContainer/Config/Files/SC/List
onready var save_name := $VBoxContainer/Top/LineEdit as LineEdit
onready var alert := $SaveName as AcceptDialog
onready var load_button := $VBoxContainer/Top/LoadButton as MenuButton
onready var match_num := $VBoxContainer/MatchCount/SpinBox as SpinBox

func _ready() -> void:
	for cat in EntryManager.get_import_categories():
		var l := single.instance()
		var new_text: String = cat
		categories.add_child(l)
		if Alias.has(cat, true):
			l.set_text(new_text, " -> " + Alias.category(cat))
		else:
			l.set_text(new_text)
	for sou in EntryManager.get_import_sources():
		var l := single.instance()
		var new_text: String = sou
		sources.add_child(l)
		if Alias.has(sou, false):
			l.set_text(new_text, " -> " + Alias.source(sou))
		else:
			l.set_text(new_text)
	for arc in EntryManager.get_archives():
		var l := single.instance()
		var new_text: String = arc
		archives.add_child(l)
		l.set_text(arc)
	update_load()
	load_button.get_popup().connect("index_pressed", self, "_on_profile_loaded")


func get_incl_categories() -> PoolStringArray:
	var cat: PoolStringArray = []
	for line in categories.get_children():
		if line.checked():
			cat.append(line.get_core())
	return cat


func get_incl_sources() -> PoolStringArray:
	var sou: PoolStringArray = []
	for line in sources.get_children():
		if line.checked():
			sou.append(line.get_core())
	return sou


func get_incl_archives() -> PoolStringArray:
	var arc: PoolStringArray = []
	for line in archives.get_children():
		if line.checked():
			arc.append(line.get_core())
	return arc


func update_load() -> void:
	load_button.get_popup().clear()
	for k in Profiles.get_keys():
		load_button.get_popup().add_item(k)


func _on_profile_loaded(idx: int) -> void:
	var id: String = load_button.get_popup().get_item_text(idx)
	var dict := Profiles.get_profile_data(id)
	if dict.has("match_count"):
		match_num.value = dict['match_count']
	if dict.has("cat"):
		for c in categories.get_children():
			if c.get_core() in dict["cat"]:
				c.set_checked()
			else:
				c.set_checked(false)
	if dict.has("sou"):
		for s in sources.get_children():
			if s.get_core() in dict["sou"]:
				s.set_checked()
			else:
				s.set_checked(false)
	if dict.has("arc"):
		for a in archives.get_children():
			if a.get_core() in dict["arc"]:
				a.set_checked()
			else:
				a.set_checked(false)
	save_name.text = id


func _on_SaveAs_pressed() -> void:
	if not save_name.text:
		alert.show()
	elif save_name.text == Profiles.RESERVED:
		alert.show()
	else:
		var t := save_name.text
		var c := get_incl_categories()
		var s := get_incl_sources()
		var a := get_incl_archives()
		var i := match_num.value
		Profiles.save_profile(t, c, s, a, i)
		update_load()


func _on_alias_created() -> void:
	for c in categories.get_children():
		if Alias.has(c.get_core(), true):
			c.set_text(c.get_core(),
					" -> " + Alias.category(c.get_core()))
		else:
			c.set_text(c.get_core())
	for s in sources.get_children():
		if Alias.has(s.get_core(), false):
			s.set_text(s.get_core(),
					" -> " + Alias.source(s.get_core()))
		else:
			s.set_text(s.get_core())


func _on_Delete_pressed() -> void:
	if save_name.text:
		Profiles.clear(save_name.text)
	update_load()

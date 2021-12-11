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

extends Node

var entries: Array # Only add Entry objects
var current_profile := ""

func _to_string() -> String:
	var out := ""
	for entry in entries:
		out = out + entry.to_string() + '\n'
	return out


func clear(which: String = "") -> void:
	if not which:
		entries.clear()
	else:
		clear_from_file(which)


func clear_from_file(which: String) -> void:
	for e in entries:
		if e.archive == which:
			entries.erase(e)


func add_entry(file: String, data: PoolStringArray) -> void:
	while data.size() < 3:
		data.append("")
	var e: Entry = Entry.new(file, data[0], data[1], data[2])
	
	if not contains_equivalent(e):
		entries.append(e)
	else:
		print("Entry: \"" + e.to_string() + "\" already present")


func contains_equivalent(e: Entry) -> bool:
	for entry in entries:
		if entry.to_string() == e.to_string():
			return true
	return false


func reset_picked() -> void:
	for e in entries:
		(e as Entry).picked = false


func pick(e: Entry) -> Entry:
	e.picked = true
	return e


func get_available_entries() -> Array:
	var unpicked := []
	for e in entries:
		if not e.picked:
			unpicked.append(e)
	
	if not current_profile:
		return unpicked
	
	var available := []
	
	if current_profile:
		for e in unpicked:
			if Profiles.profile_has_entry(e, current_profile):
				available.append(e)
	return available


func get_random_entry() -> Entry:
	if get_available_entries().size() < GlobalVars.settings["refresh"]:
		reset_picked()
	
	match GlobalVars.settings["rand"]:
		GlobalVars.RAND_CAT:
			return pick(randomize_by_category())
		GlobalVars.RAND_SOU:
			return pick(randomize_by_source())
	var es := get_available_entries()
	return pick(es[randi() % es.size()])


func randomize_by_category() -> Entry:
	var cats := get_categories()
	var cat := cats[randi() % cats.size()]
	var es := get_entries_in_category(cat)
	return es[randi() % es.size()]


func randomize_by_source() -> Entry:
	var sous := get_sources()
	var sou := sous[randi() % sous.size()]
	var es := get_entries_in_source(sou)
	return es[randi() % es.size()]


func get_categories(all := false) -> PoolStringArray:
	var cat: PoolStringArray = []
	var es: Array = entries if all else get_available_entries()
	for e in es:
		if e is Entry:
			if not e.get_game_category() in cat:
				cat.append(e.get_game_category())
	return cat


func get_sources(all := false) -> PoolStringArray:
	var sou: PoolStringArray = []
	var es: Array = entries if all else get_available_entries()
	for e in es:
		if e is Entry:
			if not e.get_game_source() in sou:
				sou.append(e.get_game_source())
	return sou


func get_entries_in_category(category: String) -> Array:
	var cat := category
	var es: Array = []
	for e in get_available_entries():
		if e is Entry:
			if e.get_game_category() == cat:
				es.append(e)
	return es


func get_entries_in_source(source: String) -> Array:
	var sou := source
	var es: Array = []
	for e in get_available_entries():
		if e is Entry:
			if e.get_game_source() == sou:
				es.append(e)
	return es


func get_import_categories() -> PoolStringArray:
	var categories: PoolStringArray = []
	for e in entries:
		if e is Entry:
			if not e.get_import_category() in categories:
				categories.append(e.get_import_category())
	return categories


func get_import_sources() -> PoolStringArray:
	var sources: PoolStringArray = []
	for e in entries:
		if e is Entry:
			if not e.get_import_source() in sources:
				sources.append(e.get_import_source())
	return sources


func get_archives() -> PoolStringArray:
	var archives: PoolStringArray = []
	for e in entries:
		if not e.archive in archives:
			archives.append(e.archive)
	return archives


func set_profile(id: String = "") -> void:
	current_profile = id

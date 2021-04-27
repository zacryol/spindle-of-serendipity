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

extends Container
signal setup

const Y_CHANGE := 51
const X_OFFSET := 29.5

const HexType := preload("res://hex_panel/HexNode.gd")

export var text: String setget set_text

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		rect_min_size = Vector2(0, 0)
		var count := 0
		for c in get_children():
			if not c is HexRow:
				continue
			
			c = c as HexRow
			c.rect_position = Vector2(X_OFFSET * (count % 2), Y_CHANGE * count)
			rect_min_size.x = max(rect_min_size.x, c.rect_size.x + X_OFFSET * (count % 2))
			rect_min_size.y = max(rect_min_size.y, c.rect_size.y + Y_CHANGE * count)
			count += 1


func split_lines(lines: String) -> PoolStringArray:
	return $StringParser.parse(lines)


func set_text(new_text: String):
	text = new_text
	
	for c in get_children():
		if c.get_index() == 0:
			continue
		c.free()
	
	for s in split_lines(new_text):
		var h := HexRow.new()
		add_child(h)
		h.line_text = s
	
	for h in get_hex_nodes(true):
		h.call_deferred("start")
		yield(h, "anim")
	emit_signal("setup")


func get_hex_nodes(randomized := false) -> Array:
	var nodes := []
	for i in range(1, get_child_count()):
		nodes += get_child(i).get_children()
	
	if randomized:
		nodes.shuffle()
	
	return nodes


func reveal_letter(letter: String) -> int:
	var count := 0
	letter = letter.substr(0, 1)
	yield(get_tree(), "idle_frame")
	for c in get_hex_nodes(true):
		if CharSet.compare(c.text, letter):
			c.current_state = HexType.State.REVEALED
			get_tree().call_group("quick_score_update", "quick_score_update")
			yield(c, "anim")
			count += 1
	return count


func add_solve(letter: String):
	for c in get_hex_nodes():
		if c.current_state == HexType.State.BLOCKED:
			c.temp(letter)
			return


func clear_solve():
	for c in get_hex_nodes():
		if c.current_state == HexType.State.TEMP:
			c.current_state = HexType.State.BLOCKED


func pop_solve() -> void:
	var nodes := get_hex_nodes()
	for i in range(nodes.size() - 1, -1, -1):
		if nodes[i].current_state == HexType.State.TEMP:
			nodes[i].current_state = HexType.State.BLOCKED
			return


func verify() -> bool:
	for c in get_hex_nodes():
		if not c.verify():
			return false
	return true


func reveal_all():
	for c in get_hex_nodes():
		c.current_state = HexType.State.REVEALED

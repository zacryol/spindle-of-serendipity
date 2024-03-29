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

const MAX_LENGTH_TO_WAIT := 75

export var text: String setget set_text

onready var audio_fail := $FailAudio as AudioStreamPlayer
onready var audio_solve := $WinAudio as AudioStreamPlayer

var scale_factor := 1.0

func _notification(what) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		rect_min_size = Vector2(0, 0)
		var count := 0
		for c in get_children():
			if not c is HexRow:
				continue
			c.rect_position = Vector2(X_OFFSET * (count % 2), Y_CHANGE * count) * scale_factor
			c.rect_scale = Vector2.ONE * scale_factor
			rect_min_size.x = max(rect_min_size.x, c.rect_size.x + X_OFFSET * (count % 2))
			rect_min_size.y = max(rect_min_size.y, c.rect_size.y + Y_CHANGE * count)
			count += 1
		rect_min_size *= scale_factor


func split_lines(input: String) -> PoolStringArray:
	var lines := PoolStringArray()
	var max_line_length: int = int(sqrt(2 * input.length()))
	var current_line: String = ""
	
	# Create lines
	for s in input.split(" "):
		if not s:
			continue
		
		if s.length() >= max_line_length:
			if current_line:
				lines.append(current_line)
				current_line = ""
		
		if current_line:
			current_line = current_line + " " + s
		else:
			current_line = s
		
		if current_line.length() >= max_line_length:
			lines.append(current_line)
			current_line = ""
	
	# Append leftover
	if current_line:
		lines.append(current_line)
	
	# Adjust indentation
	# Something goes here
	return lines


func set_text(new_text: String, force_mute := false) -> void:
	text = new_text
	var instant := text.length() > MAX_LENGTH_TO_WAIT
	for c in get_children():
		if c is Control:
			c.free()
	
	scale_factor = 1.0
	var lines := split_lines(new_text)
	var panels_size := Vector2(get_line_length(lines), lines.size())
	var scale_amount := max(panels_size.length() - Vector2(23, 9).length(), 0)
	if scale_amount:
		scale_factor -= 0.065 * scale_amount
	scale_factor = clamp(scale_factor, 0.5, 1.0)
	
	for s in lines:
		var h := HexRow.new()
		add_child(h)
		h.line_text = s
	
	for h in get_hex_nodes(true):
		h.call_deferred("start", instant or force_mute)
		if not instant:
			yield(h, "anim")
	emit_signal("setup")


func get_hex_nodes(randomized := false) -> Array:
	var nodes := []
	for i in get_child_count():
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


func add_solve(letter: String) -> void:
	for c in get_hex_nodes():
		if c.current_state == HexType.State.BLOCKED:
			c.temp(letter)
			return


func clear_solve() -> void:
	audio_fail.play()
	for c in get_hex_nodes():
		if c.current_state == HexType.State.TEMP:
			c.set_state(HexType.State.BLOCKED, true)


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


func reveal_all() -> void:
	audio_solve.play()
	for c in get_hex_nodes():
		c.set_state(HexType.State.REVEALED, true)


static func get_line_length(lines: PoolStringArray) -> int:
	var length := 0
	for l in lines:
		length = int(max(length, l.length()))
	
	return length

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

extends TextureRect

signal anim

enum State {
	BLOCKED,
	REVEALED,
	TEMP,
	EMPTY,
}

const COLOR_REVEALED := Color(0.32, 0.65, 1.00, 1.00)
const COLOR_BLOCKED := Color.black
const COLOR_TEMP := Color.mediumseagreen
const COLOR_NONE := Color.transparent

var text: String = "" setget set_text, get_text
var current_state: int = State.BLOCKED setget set_state, get_state

onready var view := $Label as Label
onready var audio := $AudioStreamPlayer as AudioStreamPlayer

func set_text(new_text: String) -> void:
	text = new_text.substr(0, 1)
	if current_state == State.REVEALED:
		view.text = text
	
	self.current_state = State.EMPTY


func start(mute := false) -> void:
	if text == " ":
		set_state(State.EMPTY, mute)
	elif not CharSet.has(text):
		set_state(State.REVEALED, mute)
	else:
		set_state(State.BLOCKED, mute)


func get_text() -> String:
	return text


func set_state(new: int, mute := false) -> void:
	var changed := new != current_state
	
	if text == " ":
		current_state = State.EMPTY
	else:
		current_state = new
	
	match current_state:
		State.BLOCKED:
			modulate = COLOR_BLOCKED
			view.text = ""
		State.REVEALED:
			modulate = COLOR_REVEALED
			view.text = text
		State.TEMP:
			modulate = COLOR_TEMP
		State.EMPTY:
			view.text = ""
			modulate = COLOR_NONE
	if changed and not current_state == State.EMPTY:
		$AnimationPlayer.play("change")
		if not mute:
			audio.play()
		else:
			audio.stop()
	else:
		enough()


func get_state() -> int:
	return current_state


func temp(guess: String) -> void:
	set_state(State.TEMP)
	view.text = guess.substr(0, 1)


func verify() -> bool:
	match current_state:
		State.REVEALED:
			return true
		State.EMPTY:
			return true
		State.BLOCKED:
			return false
		State.TEMP:
			return CharSet.compare(view.text, text)
	
	return false


func enough() -> void:
	emit_signal("anim")

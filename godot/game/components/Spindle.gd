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

signal score(points, final)
signal spun

enum State {
	INACTIVE, # Not enabled. Something else needs to be done.
	ACTIVE, # Enabled. Player needs to click
	RUNNING, # Spinning. Click to set score
}

onready var anim := $AnimationPlayer as AnimationPlayer
onready var scores := $SpindleScores as Control
onready var bt := $Button as Button

var current_state: int = State.INACTIVE
var current_value: int


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spindle") and not bt.disabled:
		if not bt.disabled:
			_on_Button_pressed()


func set_state(new_state: int) -> void:
	current_state = new_state
	match new_state:
		State.INACTIVE:
			set_button_enabled(false)
			bt.text = "Spin!"
		State.ACTIVE:
			set_button_enabled(true)
			bt.text = "Spin!"
		State.RUNNING:
			set_button_enabled(false)
			yield(get_tree().create_timer(0.5), "timeout")
			set_button_enabled(true)
			bt.text = "Strike!"


func set_button_enabled(enabled: bool) -> void:
	bt.disabled = not enabled
	bt.focus_mode = Control.FOCUS_ALL if enabled else FOCUS_NONE
	if enabled:
		bt.grab_focus()


func _letters_guessed(number: int, solves: bool) -> void:
	set_state(State.INACTIVE)
	emit_signal("score", number * current_value, solves)


func _on_Button_pressed() -> void:
	match current_state:
		State.ACTIVE:
			set_state(State.RUNNING)
			anim.play("Back")
			scores.start()
		State.RUNNING:
			emit_signal("game_log", "")
			anim.play("Forward")
			yield(anim, "animation_finished")
			current_value = scores.stop()
			set_state(State.INACTIVE)
			emit_signal("game_log", str(current_value) + " points per letter")
			emit_signal("spun")
			get_tree().set_group_flags(SceneTree.GROUP_CALL_REALTIME, "tracks_spindle_score", "_spindle_score", current_value)


func _on_PlayersPanel_turn_done() -> void:
	set_state(State.ACTIVE)


func _on_EntryDisplay_text_ready() -> void:
	set_state(State.ACTIVE)

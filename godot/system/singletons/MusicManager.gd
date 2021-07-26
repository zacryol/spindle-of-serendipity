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

export var menu_music: AudioStream
export var final_round_music: AudioStream
export var end_game_music: AudioStream
export var side_menu_music : AudioStream
export (Array, AudioStream) var game_tracks := []

onready var player := $AudioStreamPlayer as AudioStreamPlayer
onready var tween := $FadeTween as Tween

func play_song(song: AudioStream, fade := false, fade_out_duration := 1.0, fade_in_duration := 0.1) -> void:
	if player.stream == song:
		return
	
	if fade:
		if player.playing:
			tween.remove_all()
			tween.interpolate_property(player, "volume_db", 0, -90, fade_out_duration)
			tween.start()
			yield(tween, "tween_all_completed")
		player.stream = song
		player.play()
		tween.remove_all()
		tween.interpolate_property(player, "volume_db", -90, 0, fade_in_duration)
		tween.start()
	else:
		player.stream = song
		player.play()


func play_song_id(id: String, fade := false) -> void:
	match id:
		"menu":
			play_song(menu_music, fade)
		"final":
			play_song(final_round_music, fade)
		"end":
			play_song(end_game_music, fade)
		"side":
			play_song(side_menu_music, fade)


func play_game_music() -> void:
	play_song(game_tracks[randi() % game_tracks.size()])

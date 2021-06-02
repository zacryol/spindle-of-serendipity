extends Node

export var menu_music: AudioStream
export var final_round_music: AudioStream
export var end_game_music: AudioStream
export var side_menu_music : AudioStream
export (Array, AudioStream) var game_tracks := []

onready var player := $AudioStreamPlayer as AudioStreamPlayer
onready var tween := $FadeTween as Tween


func _ready() -> void:
	pass


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
		pass
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

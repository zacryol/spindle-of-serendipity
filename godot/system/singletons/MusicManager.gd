extends Node

export var menu_music: AudioStream
export (Array, AudioStream) var game_tracks := []

onready var player := $AudioStreamPlayer as AudioStreamPlayer
onready var tween := $FadeTween as Tween

func _ready() -> void:
	pass


func play_song(song: AudioStream, fade := false) -> void:
	if fade:
		pass
	else:
		player.stream = song
		player.play()


func play_song_id(id: String, fade := false) -> void:
	pass


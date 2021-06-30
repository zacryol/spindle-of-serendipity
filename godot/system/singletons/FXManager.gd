extends Node

func _ready() -> void:
	toggle_crt(GlobalVars.settings.crt_on)


func toggle_crt(on: bool) -> void:
	$FrontShader/TextureRect.visible = on

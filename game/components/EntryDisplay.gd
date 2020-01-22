extends Control


func _ready():
	pass

func set_display(entry : Entry):
	$EntryLabel.text = entry.get_entry_text()
	$CategoryLabel.text = entry.get_game_category()
	$SourceLabel.text = entry.get_game_source()
	pass

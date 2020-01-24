extends Control

var entry_text : String
var bool_mask : Dictionary = {
	"A":false,
	"B":false,
	"C":false,
	"D":false,
	"E":false,
	"F":false,
	"G":false,
	"H":false,
	"I":false,
	"J":false,
	"K":false,
	"L":false,
	"M":false,
	"N":false,
	"O":false,
	"P":false,
	"Q":false,
	"R":false,
	"S":false,
	"T":false,
	"U":false,
	"V":false,
	"W":false,
	"X":false,
	"Y":false,
	"Z":false
}

func _ready():
	pass

func set_display(entry : Entry):
	entry_text = entry.get_entry_text().to_upper()
	$EntryLabel.text = entry.get_entry_text()
	$CategoryLabel.text = entry.get_game_category()
	$SourceLabel.text = entry.get_game_source()
	pass

func get_display_text() -> String:
	return ""

extends "res://game/components/GameComponent.gd"

signal letters_revealed(number, final)
signal one_letter(letter)
signal guess_checked(solved)

enum {
	MODE_DISABLED,
	MODE_LETTER,
	MODE_SOLVE,
}
var current_mode := MODE_DISABLED
var entry_text: String
var source_text: String
var bool_mask: Dictionary
var source_hide := "???"
var solve_stack: PoolStringArray = []

onready var hex := $PanelContainer/ScrollContainer/HexWrapper/HexContainer

func _ready():
	bool_mask.clear()
	for c in CharSet.CHAR_MAIN:
		bool_mask[c] = false
	pass


func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and \
				not event.is_echo() and \
				event.scancode == KEY_BACKSPACE:
			if solve_stack.size():
				solve_stack.remove(solve_stack.size() - 1)
				hex.pop_solve()


func set_display(entry: Entry):
	entry_text = entry.get_entry_text().to_upper()
	source_text = entry.get_game_source()
	
	for k in bool_mask.keys():
		bool_mask[k] = false
	
	$CategoryLabel.text = entry.get_game_category()
	if GlobalVars.show_source == GlobalVars.SOURCE_ALWAYS:
		$SourceLabel.text = source_text
	elif GlobalVars.show_source == GlobalVars.SOURCE_NEVER:
		$SourceLabel.text = ""
	else:
		$SourceLabel.text = source_hide
	
	hex.text = entry_text


func is_solved() -> bool:
	return hex.verify()


func get_letters_in_entry() -> PoolStringArray:
	var letters: PoolStringArray = []
	for i in entry_text.length():
		var current_char := get_char_at(i)
		if bool_mask.has(current_char):
			if not current_char in letters:
				letters.append(current_char)
	return letters


func get_char_at(index: int) -> String:
	return entry_text.substr(index, 1)


func _on_letter_guessed(letter: String):
	if current_mode == MODE_LETTER:
		single_letter_guessed(letter)
	elif current_mode == MODE_SOLVE:
		add_solve(letter)


func single_letter_guessed(letter: String):
	var guess := letter.substr(0, 1)
	if !bool_mask.has(guess):
		return 
	if bool_mask[guess] == false:
		bool_mask[guess] = true
		
		hex.reveal_letter(guess)
		
		var num := count_char(guess)
		emit_signal("game_log", str(num) + " revealed")
		emit_signal("letters_revealed", num, is_solved())
		current_mode = MODE_DISABLED
		emit_signal("one_letter", letter)
	else:
		emit_signal("game_log", guess + " has already been guessed")
	if is_solved() && GlobalVars.show_source == GlobalVars.SOURCE_SOLVE:
		$SourceLabel.text = source_text


func count_char(c: String) -> int:
	c = c.substr(0, 1)
	var count := 0
	for i in entry_text.length():
		if CharSet.compare(c, get_char_at(i)):
			count += 1
	return count


func add_solve(letter: String):
	if bool_mask.has(letter) and not bool_mask[letter]:
		solve_stack.append(letter)
		hex.add_solve(letter)


func check_solve() -> bool:
	return hex.verify()


func init_solve():
	solve_stack = []
	current_mode = MODE_SOLVE
	$SolveUI.show()


func _on_Spindle_spun():
	current_mode = MODE_LETTER


func _on_SolveButton_pressed():
	var solved := check_solve()
	$SolveUI.hide()
	emit_signal("guess_checked", solved)
	solve_stack = []
	hex.clear_solve()
	current_mode = MODE_DISABLED
	if solved:
		hex.reveal_all()
		for k in bool_mask.keys():
			bool_mask[k] = true
		if GlobalVars.show_source == GlobalVars.SOURCE_SOLVE:
			$SourceLabel.text = source_text


func _on_BSpace_pressed():
	solve_stack.remove(solve_stack.size() - 1)
	hex.pop_solve()
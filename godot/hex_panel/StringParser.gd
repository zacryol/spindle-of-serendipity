extends Node


func parse(input: String) -> PoolStringArray:
	var lines := PoolStringArray()
	var max_line_length: int = floor(sqrt(2 * input.length()))
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

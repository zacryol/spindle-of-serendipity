extends Node


func parse(input: String) -> PoolStringArray:
	var lines: PoolStringArray
	var max_line_length := sqrt(2 * input.length())
	var current_line: String = ""
	
	# Create lines
	for s in input.split(" "):
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


func is_broke(lines: PoolStringArray) -> bool:
	# Check if any gaps go from top to bottom
	# For each space in the top row, check if either node below is also a space
	#	Or beyond line end
	#	recursively
	# For even rows (0, 2, 4) and given space x check nodes in next row at positions x and x - 1
	# For odds (1, 3, 5) check x and x + 1
	
	
	return true


func longest_line_in(lines: PoolStringArray) -> int:
	if lines.size() == 1:
		return 0
	
	var line_id := 0
	for i in range(1, lines.size()):
		if lines[i].length() > lines[line_id].length():
			line_id = i
	
	return line_id

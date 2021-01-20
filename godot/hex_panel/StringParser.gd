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


func parse(input: String) -> PoolStringArray:
	var lines := PoolStringArray()
	var max_line_length: int = int(sqrt(2 * input.length()))
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

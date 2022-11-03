extends GridMap

export (int) var tile_index = 0

const y_val = 0


func _ready():
	self.set_cell_item(0, 0, 0, 1)


## Positions is an array of 2 element arrays [x, y] of tile pos
func set_positions(positions):
	for position in positions:
		self.set_cell_item(position[0], y_val, position[1], tile_index)


func unset_positions(positions):
	for position in positions:
		self.set_cell_item(position[0], y_val, position[1], -1)

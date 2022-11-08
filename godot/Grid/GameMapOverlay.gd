extends GridMap

export (int) var tile_index = 0
export (int) var facing_tile_index = 1

const y_val = 0


func _ready():
	pass


## Positions is an array of 2 element arrays [x, y] of tile pos
func set_positions(positions):
	for position in positions:
		self.set_cell_item(position[0], y_val, position[1], tile_index)


func set_facing_position(position):
	self.set_cell_item(position[0], y_val, position[1], facing_tile_index)


func unset_positions(positions):
	for position in positions:
		self.set_cell_item(position[0], y_val, position[1], -1)

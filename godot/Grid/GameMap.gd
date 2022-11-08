extends GridMap

export (NodePath) var _overlay_map
onready var overlay_map = get_node(_overlay_map)


func _ready():
	print("meshes")
	print(self.get_bake_meshes())


func get_tile_world_pos(pos_x: int, pos_y: int) -> Vector3:
	return self.map_to_world(pos_x, 0, pos_y)


func set_target_cell(pos):
	print("Game Map set_target_cell", pos)
	if pos != null:
		# Find target
		var world = self.world_to_map(pos)
		print("World: ", world)
		var cell = self.get_cell_item(world.x, 0, world.z)
		print("Cell:", cell)

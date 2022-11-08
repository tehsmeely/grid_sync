extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var unit_scene
export (NodePath) var _game_map
export (NodePath) var _game_overlay_map
onready var game_map = get_node(_game_map)
onready var game_overlay_map = get_node(_game_overlay_map)

onready var units = $Units


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Game Map (0,0,0): ", game_map.get_tile_world_pos(0, 0))
	self.spawn_unit()
	self.spawn_unit()
	self.spawn_unit()
	self.set_process(true)


func _process(_delta):
	if Input.is_action_just_pressed("dbg_rot"):
		for c in units.get_children():
			if "orientation" in c:
				if c.orientation == 3:
					c.orientation = 0
				else:
					c.orientation += 1

	if Input.is_action_just_pressed("dbg_move"):
		for c in units.get_children():
			if c.has_method("move_forward"):
				c.move_forward()

	if Input.is_action_just_pressed("dbg_show_moves"):
		game_map.overlay_map.clear()
		for c in units.get_children():
			if c.has_method("draw_moves"):
				c.draw_moves()

	if Input.is_action_just_pressed("dbg_execute"):
		self.execute()


func get_unit_by_name(name):
	for unit in units.get_children():
		if unit.unit_name == name:
			return unit
	return null


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var last_tile_pos = [0, -2]
var last_name = 1
var x_per_step = 0
var y_per_step = 2


func spawn_unit():
	assert(self.game_map != null)
	var unit = unit_scene.instance()
	unit.game_map = self.game_map
	units.add_child(unit)
	unit.unit_name = str(last_name)
	unit.set_tile_pos(last_tile_pos[0], last_tile_pos[1])
	last_tile_pos[0] = last_tile_pos[0] + x_per_step
	last_tile_pos[1] = last_tile_pos[1] + y_per_step
	last_name += 1

func execute():
	for unit in units.get_children():
		unit.execute_queued()
extends Spatial

export (int) var tile_pos_x = 0
export (int) var tile_pos_y = 0
export (int) var orientation = 0 setget _set_orientation

onready var label = $Label3D

var game_map
var unit_name = "" setget _set_unit_name

var position_offset = Vector3(0.0, 2.0, 0.2)
var queued_action = null


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Unit. Ready.   Game map: ", self.game_map)
	self._set_orientation(orientation)


func move_forward():
	var moves = _orientation_to_tile_move(orientation)
	tile_pos_x += moves[0]
	tile_pos_y += moves[1]
	_update_translation()


func _gen_straight():
	var positions = []
	var last = [self.tile_pos_x, tile_pos_y]
	var move = _orientation_to_tile_move(orientation)
	for _i in range(4):
		last[0] += move[0]
		last[1] += move[1]
		positions.append(last.duplicate())

	return positions


func _gen_l_shape(stalk_len):
	var positions = []
	var last = [self.tile_pos_x, tile_pos_y]
	var move = _orientation_to_tile_move(orientation)
	var max_ = stalk_len
	for i in range(max_):
		last[0] += move[0]
		last[1] += move[1]
		positions.append(last.duplicate())
		if i == max_ - 1:
			if move[0] == 0:
				last[0] += move[1]
			else:
				last[1] += move[0]
			positions.append(last.duplicate())
	return positions


func _gen_knight():
	return _gen_l_shape(3)


func _gen_turn():
	return _gen_l_shape(2)


func _move_step_by_orientation_after_turn(point, turn):
	var new_orientation = _turn_orientation(self.orientation, turn)
	var move = _orientation_to_tile_move(new_orientation)
	var facing = [point[0] + move[0], point[1] + move[1]]
	print("Move step by turned orientation")
	print("last point: ", point)
	print("new orientation: ", new_orientation)
	print("move: ", move)
	print("facing: ", facing)
	return facing


func _internal_queue_action(name, points, turn):
	game_map.overlay_map.set_positions(points)
	var facing_position = _move_step_by_orientation_after_turn(points[-1].duplicate(), turn)
	game_map.overlay_map.set_facing_position(facing_position)
	self.queued_action = {
		"name": name, "points": points, "turn": turn, "facing_position": facing_position
	}


func clear_queued_action():
	if self.queued_action != null:
		print("Clearing action: ", self.queued_action["name"])
		game_map.overlay_map.unset_positions(self.queued_action["points"])
		game_map.overlay_map.unset_positions([self.queued_action["facing_position"]])
		self.queued_action = null


func queue_action(action_name):
	match action_name:
		"straight":
			self.clear_queued_action()
			self._internal_queue_action("straight", _gen_straight(), 0)
		"knight":
			self.clear_queued_action()
			self._internal_queue_action("knight", _gen_knight(), 0)
		"turn":
			self.clear_queued_action()
			self._internal_queue_action("turn", _gen_turn(), -1)
		"flip":
			pass
		_:
			print("Unknown unit action: ", action_name)


func set_tile_pos(x, y):
	tile_pos_x = x
	tile_pos_y = y
	_update_translation()


func _update_translation():
	print("Updating translation: ", self.game_map)
	assert(game_map != null)
	var world_pos = game_map.get_tile_world_pos(tile_pos_x, tile_pos_y)
	self.translation = (world_pos + position_offset)


func _set_orientation(new_ori):
	orientation = new_ori
	self.rotation.y = _orientation_to_rad(orientation)


func _set_unit_name(name):
	unit_name = name
	_set_label_text(name)


func _set_label_text(text):
	if label != null:
		label.text = text


func _turn_orientation(ori: int, turn: int) -> int:
	var new_ori = ori + turn
	if new_ori < 0:
		return new_ori + 4
	elif new_ori > 3:
		return new_ori - 4
	else:
		return new_ori


func _orientation_to_rad(ori: int) -> float:
	match ori:
		0:
			return 0.0
		1:
			return PI / 2.0
		2:
			return PI
		3:
			return PI + (PI / 2.0)
		_:
			return 0.0


func _orientation_to_tile_move(ori: int) -> Array:
	match ori:
		0:
			return [-1, 0]
		1:
			return [0, 1]
		2:
			return [1, 0]
		3:
			return [0, -1]
		_:
			return [0, 0]

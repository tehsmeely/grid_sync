extends Node

export (NodePath) var grid
export (int, LAYERS_3D_PHYSICS) var collision_mask = 1

onready var camera := get_parent()
onready var raycast := $RayCast
var grid_


# Called when the node enters the scene tree for the first time.
func _ready():
	grid_ = self.get_node(grid)
	if grid_ == null:
		assert(false, "Grid must be provided")
	pass  # Replace with function body.


func _finput(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			_select_target(event.position)


func _select_target(click_position: Vector2) -> void:
	var from_ = camera.project_ray_origin(click_position)
	var to_ = from_ + camera.project_ray_normal(click_position) * 1000
	var space_state = camera.get_world().direct_space_state
	print(from_, to_)
	var ray_result = space_state.intersect_ray(from_, to_, [], collision_mask)
	if ray_result:
		print(ray_result)
		grid_.set_target_cell(ray_result["position"])
	else:
		grid_.set_target_cell(null)

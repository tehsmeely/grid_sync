extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var level_manager = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = find_node("UnitElement").connect("unit_input", self, "_on_button_unit_input")
	var _err1 = find_node("UnitElement2").connect("unit_input", self, "_on_button_unit_input")
	var _err2 = find_node("UnitElement3").connect("unit_input", self, "_on_button_unit_input")
	var _err3 = find_node("UnitElement4").connect("unit_input", self, "_on_button_unit_input")


func _on_button_unit_input(unit_id: String, action: String) -> void:
	print("Unit input: ", unit_id, action)

	var unit = level_manager.get_unit_by_name(unit_id)

	if unit != null:
		print("Found unit: ", unit)
		unit.queue_action(action)
	else:
		print("Did not find unit: ", unit_id)

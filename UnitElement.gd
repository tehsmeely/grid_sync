extends MarginContainer

signal unit_input(unit_id, action_name)

onready var button_straight = $VSplitContainer/VBoxContainer/Straight
onready var button_knight = $VSplitContainer/VBoxContainer/Knight
onready var button_turn = $VSplitContainer/VBoxContainer/Turn

onready var button_flip = $VSplitContainer/VBoxContainer/Flip

onready var label = $VSplitContainer/Label

export (String) var label_text setget _set_label_text


# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = button_straight.connect("pressed", self, "_straight_pressed")
	var _err1 = button_knight.connect("pressed", self, "_knight_pressed")
	var _err2 = button_turn.connect("pressed", self, "_turn_pressed")
	var _err3 = button_flip.connect("pressed", self, "_flip_pressed")
	label = $VSplitContainer/Label
	self.label_text = label_text


func _set_label_text(t):
	label_text = t
	if label != null:
		label.text = t


func _straight_pressed():
	emit_signal("unit_input", label_text, "straight")


func _knight_pressed():
	emit_signal("unit_input", label_text, "knight")


func _turn_pressed():
	emit_signal("unit_input", label_text, "turn")


func _flip_pressed():
	emit_signal("unit_input", label_text, "flip")

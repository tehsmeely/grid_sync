extends MeshInstance

export (float) var targeted_highlight_strength = 0.5

var shader = self.mesh.material.next_pass
var targeted := false setget set_targeted


func set_targeted(new_t: bool):
	print("Targeted set: ", new_t)
	if targeted != new_t:
		targeted = new_t
		if targeted:
			shader.set_shader_param("strength", targeted_highlight_strength)
		else:
			shader.set_shader_param("strength", 0.0)

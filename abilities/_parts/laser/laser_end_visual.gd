extends MeshInstance3D

func show_fired(distance: float) -> void:
	position = Vector3.FORWARD * distance / 2
	mesh.height = distance
	visible = true

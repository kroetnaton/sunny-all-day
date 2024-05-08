extends MeshInstance3D

@onready var raycast: RayCast3D = $"../RayCast3D"

func _ready() -> void:
	mesh = ImmediateMesh.new()

func _process(_delta: float) -> void:
	var endpoint: Vector3 = raycast.get_collision_point() if raycast.is_colliding() \
			else to_global(raycast.target_position)
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	mesh.surface_add_vertex(global_position * global_transform)
	mesh.surface_add_vertex(endpoint * global_transform)
	mesh.surface_end()

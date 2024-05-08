extends MeshInstance3D

var initilized: bool = false
var target: Vector3
var muzzle: Marker3D

func _ready() -> void:
	mesh = ImmediateMesh.new()

func _process(_delta: float) -> void:
	if not initilized:
		initilized = true
		var ability_base: AbilityBase = get_parent().ability_base
		target = ability_base.target_point
		muzzle = ability_base.muzzle
	elif is_instance_valid(muzzle):
		mesh.clear_surfaces()
		mesh.surface_begin(Mesh.PRIMITIVE_LINES)
		mesh.surface_add_vertex(muzzle.global_position * global_transform)
		mesh.surface_add_vertex(target * global_transform)
		mesh.surface_end()

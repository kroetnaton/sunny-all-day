extends Node3D
class_name CircleSpawner

@export var part: Enums.Parts
@onready var resource: Resource = AbilityPartLoader.preload_dict[part]

var objs: int
var current_obj: int = 0
var circle_rad: float
var difference_to_layer: int
var layer_distance: float

var current_layer: int = 0
var layers: Array = []
var layers_changing: Array

func initiate(objs_to_spawn: int, full_circle_in_rad: float=PI, distance_between_layers: float=1) -> void:
	objs = objs_to_spawn
	circle_rad = full_circle_in_rad
	difference_to_layer = 1 if circle_rad != 2 * PI else 0
	layer_distance = distance_between_layers
	
	# Calculate layers and distribution
	var objs_in_layer: int = 1
	while objs_to_spawn > 0:
		layers.append(objs_in_layer)
		layers_changing.append(0)
		objs_to_spawn -= objs_in_layer
		objs_in_layer += objs_in_layer + 1
		if objs_in_layer > objs_to_spawn:
			objs_in_layer = objs_to_spawn

func has_spawn_next() -> bool:
	return current_obj < objs

func spawn_next(target: Vector3, target_is_direction: bool = false) -> Node3D:
	var obj: Node3D = resource.instantiate()
	add_child(obj)
	obj.top_level = false
	
	# Make sure the beam next beam is always at a new position in a circle pattern
	var step_size: float = circle_rad / (max(1, layers[current_layer] - difference_to_layer))
	var offset: Vector3 = Vector3.UP * layer_distance * current_layer
	var rotate_rad: float = step_size * layers_changing[current_layer] - circle_rad / 2
	offset = offset.rotated(Vector3.FORWARD, rotate_rad)
	
	obj.rotate(Vector3.FORWARD, rotate_rad)
	obj.position += offset
	
	if target_is_direction:
		target += obj.global_position
	obj.look_at(target, obj.transform.basis.y)
	
	current_obj += 1
	layers_changing[current_layer] += 1
	if layers_changing[current_layer] == layers[current_layer]:
		current_layer += 1
	return obj

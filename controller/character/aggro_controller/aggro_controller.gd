extends Node3D
class_name AggroController

@export var aggro_radius = 30.0
@export var deaggro_radius = 0.0
@export_flags_3d_physics var aggro_mask: int
@export_flags_3d_physics var blocking_mask: int
@export var necessary_fields: Array[String] = ["life_controller"]

@onready var sightline: RayCast3D = $Sightline
@onready var aggroArea: Area3D = $AggroArea
@onready var aggroShape: CollisionShape3D = $AggroArea/CollisionShape3D
@onready var deaggroArea: Area3D = $DeaggroArea
@onready var deaggroShape: CollisionShape3D = $DeaggroArea/CollisionShape3D

var targets_in_range: Array[Node3D] = []
var target: Node3D

func _ready() -> void:
	aggroArea.collision_mask = aggro_mask
	aggroShape.shape.radius = aggro_radius
	deaggroArea.collision_mask = aggro_mask
	deaggroShape.shape.radius = deaggro_radius
	sightline.collision_mask = blocking_mask
	sightline.target_position = Vector3.FORWARD * aggro_radius

func _process(_delta: float) -> void:
	if is_instance_valid(target):
		return
	for possible_target: Node3D in targets_in_range:
		look_at(possible_target.global_position)
		if possible_target == sightline.get_collider():
			target = possible_target
			return

func _on_aggro_area_body_entered(body: Node3D) -> void:
	for field: String in necessary_fields:
		if field in body:
			targets_in_range.append(body)

func _on_aggro_area_body_exited(body: Node3D) -> void:
	targets_in_range.erase(body)

func _on_deaggro_area_body_exited(body: Node3D) -> void:
	if body == target:
		target = null

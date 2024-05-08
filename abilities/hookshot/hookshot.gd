extends Node3D

@onready var ability_base: AbilityBase = $AbilityBase
@onready var target_visual: MeshInstance3D = $TargetVisual
var movement_controller: MovementController
var muzzle: Marker3D

@export var speed: int = 30
@export var stop_distance: float = 0.5
@export var max_duration: float = 4.0
var duration: float = max_duration
var is_target_reached: bool = false

func _initilise() -> void:
	if not ability_base.is_target_collision:
		ability_base.cooldown = 0.0
		queue_free()
		return
	visible = true
	target_visual.global_position = ability_base.target_point
	movement_controller = ability_base.parent.movement_controller
	muzzle = ability_base.muzzle

func _process(delta: float) -> void:
	duration -= delta
	if duration <= 0.0 or not is_instance_valid(ability_base.parent) or \
			not is_instance_valid(movement_controller) or not is_instance_valid(muzzle):
		queue_free()
		return
	
	# Move parent to target until reached, then keep parent there
	movement_controller.lock_movement()
	if stop_distance < muzzle.global_position.distance_to(ability_base.target_point) and not is_target_reached:
		movement_controller.force_move_direction(
			muzzle.global_position.direction_to(ability_base.target_point), speed)
	else:
		is_target_reached = true

func _uncast(_ability_base: AbilityBase) -> void:
	queue_free()

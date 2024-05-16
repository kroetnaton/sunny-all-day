extends Node3D
class_name MovementController

@export var speed: float = 15.0
@export var air_speed_multiplier:float = 0.4
@export var max_jumps: int = 2
@export var jump_velocity: float = 10.0
@export var jump_cooldown: float = 0.2
var jump_timer: float = jump_cooldown
var jump_count: int = 0

@onready var parent: CharacterBody3D = get_parent()
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_gravity: float = 0.0

var effect_container: Dictionary = {}
var movement: Vector3 = Vector3.ZERO
var jump: bool = false

const HORIZONTAL_MOVEMENT: Vector3 = Vector3(1, 0, 1)
const VERTICAL_MOVEMENT: Vector3 = Vector3(0, 1, 0)

func set_movement(added_movement: Vector3 = Vector3.ZERO, is_jump: bool = false) -> void:
	movement = parent.transform.basis * added_movement
	jump = jump || is_jump

func add_movement_effect(effect_name: String, duration: float, effect_force_movement: Vector3 = Vector3.ZERO,
		speed_factor: float = 1.0, fall_factor: float = 1.0, disable_jump: bool = false, added_jumps: int = 0) -> void:
	effect_container[effect_name] = MovementEffect.new(duration, effect_force_movement, speed_factor, fall_factor,
			disable_jump, added_jumps)

func _physics_process(delta: float) -> void:
	var effects: MovementEffect = get_and_clean_effects(delta)
	if jump_timer > 0:
		jump_timer -= delta
	var is_jumping: bool = jump and jump_timer < 0.0 and not effects.disable_jump and \
			jump_count < max_jumps + effects.added_jumps
	jump = false
	
	movement = movement if movement == Vector3.ZERO else movement.normalized()
	if is_jumping:
		jump_count += 1
		jump_timer = jump_cooldown
		movement.y = jump_velocity
	else:
		if parent.is_on_floor():
			jump_count = 0
			current_gravity = 0.0
		else:
			movement.y += parent.velocity.y - gravity * delta
	
	movement = movement * HORIZONTAL_MOVEMENT * speed * effects.speed_factor + \
			movement * VERTICAL_MOVEMENT * effects.fall_factor
	parent.velocity = movement + effects.force_movement
	parent.move_and_slide()

func get_and_clean_effects(delta: float) -> MovementEffect:
	var effect_data: MovementEffect = MovementEffect.new(0.0, Vector3.ZERO, 1.0, 1.0, false, 0)
	for key: String in effect_container:
		var entry: MovementEffect = effect_container[key]
		if entry.duration < 0.0:
			effect_container.erase(key)
		else:
			entry.duration -= delta
		effect_data.force_movement += entry.force_movement
		effect_data.speed_factor *= entry.speed_factor
		effect_data.fall_factor *= entry.fall_factor
		effect_data.disable_jump = effect_data.disable_jump || entry.disable_jump
		effect_data.added_jumps += entry.added_jumps
	return effect_data

class MovementEffect:
	var duration: float = 0.0
	var force_movement: Vector3 = Vector3.ZERO
	var speed_factor: float = 1.0
	var fall_factor: float = 1.0
	var disable_jump: bool = false
	var added_jumps: int = 0
	func _init(duration_i: float, force_movement_i: Vector3, speed_factor_i: float, fall_factor_i: float,
			disable_jump_i: bool, added_jumps_i: int) -> void:
		duration = duration_i
		force_movement = force_movement_i
		speed_factor = speed_factor_i
		fall_factor = fall_factor_i
		disable_jump = disable_jump_i
		added_jumps = added_jumps_i

extends Node3D
class_name MovementController

@export var speed_multiplier: float = 15.0
@export var jump_acceleration: Vector3 = Vector3.UP * 15
@export var gravity: Vector3 = Vector3.DOWN
@export var air_speed_multiplier:float = 0.4

var effect_container: Dictionary = {}

@export var default_jump_max_count: int = 2
var jump_max_count: int = default_jump_max_count
var jump_count: int = jump_max_count
var jump_cooldown: float = 0.2
var jump_timer: float = jump_cooldown

var move_multiplier: float = 1.0
var fall_multiplier: float = 1.0
var can_jump: bool = true

@onready var parent: CharacterBody3D = get_parent()
var movement: Vector3 = Vector3.ZERO
var force_movement: Vector3 = Vector3.ZERO

const HORIZONTAL_MOVEMENT: Vector3 = Vector3(1, 0, 1)
const VERTICAL_MOVEMENT: Vector3 = Vector3.UP

func set_movement(direction: Vector3 = Vector3.ZERO, jump: bool = false) -> void:
	movement = (parent.transform.basis * direction).normalized() * speed_multiplier
	if jump and can_jump and jump_count > 0 and jump_timer < 0:
		jump_count -= 1
		jump_timer = jump_cooldown
		movement += jump_acceleration

func add_movement_effect(effect_name: String, duration: float, effect_force_movement: Vector3 = Vector3.ZERO,
		speed_factor: float = 1.0, fall_factor: float = 1.0,
		disable_jump: bool = false, added_jumps: int = 0) -> void:
	effect_container[effect_name] = MovementEffect.new(duration, effect_force_movement, speed_factor, fall_factor,
			disable_jump, added_jumps)

func _physics_process(delta: float) -> void:
	handle_and_clean_effects(delta)
	
	if jump_timer > 0:
		jump_timer -= delta
	
	if parent.is_on_floor():
		# Only refill jump_count if it's possible to jump again
		if jump_count != jump_max_count and jump_timer < 0:
			jump_count = jump_max_count
	else:
		# Keep part of velocity and limit movement in the air
		var original_length: float = (parent.velocity * HORIZONTAL_MOVEMENT).length()
		var original_direction: Vector3 = (parent.velocity * HORIZONTAL_MOVEMENT).normalized()
		var added_direction: Vector3 = (movement * HORIZONTAL_MOVEMENT).normalized()
		movement = max(original_length, speed_multiplier * air_speed_multiplier) * (
					original_direction * (1 - air_speed_multiplier) + added_direction * air_speed_multiplier
				) + movement * VERTICAL_MOVEMENT
		
		# Stop falling during upward momentum
		if movement.y <= 0:
			movement += parent.velocity * VERTICAL_MOVEMENT + gravity
	
	movement = movement * HORIZONTAL_MOVEMENT * move_multiplier + movement * VERTICAL_MOVEMENT * fall_multiplier
	parent.velocity = movement + force_movement
	parent.move_and_slide()

func handle_and_clean_effects(delta: float) -> void:
	force_movement = Vector3.ZERO
	move_multiplier = 1.0
	fall_multiplier = 1.0
	can_jump = true
	jump_count = jump_max_count
	for key: String in effect_container:
		var entry: MovementEffect = effect_container[key]
		if entry.duration < 0.0:
			effect_container.erase(key)
		else:
			entry.duration -= delta
		force_movement += entry.force_movement
		move_multiplier *= entry.speed_factor
		fall_multiplier *= entry.fall_factor
		can_jump = can_jump && not entry.disable_jump
		jump_count += entry.added_jumps

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

extends Node3D
class_name MovementController

@export var speed_multiplier: float = 15.0
@export var jump_acceleration: Vector3 = Vector3.UP * 15
@export var gravity: Vector3 = Vector3.DOWN
@export var air_speed_multiplier:float = 0.4

@export var jump_max_count: int = 2
var jump_count: int = jump_max_count
var jump_cooldown: float = 0.2
var jump_timer: float = jump_cooldown

var move_multiplier: float = 1.0
var fall_multiplier: float = 1.0
var can_jump: bool = true

@onready var parent: CharacterBody3D = get_parent()
var movement: Vector3 = Vector3.ZERO
var force_movement: Vector3 = Vector3.ZERO

var HORIZONTAL_MOVEMENT: Vector3 = Vector3(1, 0, 1)
var VERTICAL_MOVEMENT: Vector3 = Vector3.UP

func move_direction(direction: Vector3, is_local: bool = true) -> void:
	if is_local:
		direction = parent.transform.basis * direction
	movement += direction.normalized() * speed_multiplier

func force_move_direction(direction: Vector3, speed: float, is_local: bool = false) -> void:
	if is_local:
		direction = parent.transform.basis * direction
	force_movement += direction.normalized() * speed

func lock_movement() -> void:
	move_multiplier *= 0.0
	fall_multiplier *= 0.0
	can_jump = false

func jump() -> void:
	if can_jump and jump_count > 0 and jump_timer < 0:
		jump_count -= 1
		jump_timer = jump_cooldown
		movement += jump_acceleration

func _physics_process(delta) -> void:
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
	
	# Reset all necessary fields
	movement = Vector3.ZERO
	force_movement = Vector3.ZERO
	move_multiplier = 1.0
	fall_multiplier = 1.0
	can_jump = true

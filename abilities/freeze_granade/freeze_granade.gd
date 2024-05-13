extends CharacterBody3D

@onready var ability_base: AbilityBase = $AbilityBase
@onready var explosion_area: Area3D = $ExplosionArea

@export var speed: float = 50.0
@export var flight_duration: float = 5
@export var explosion_duration: float = 0.3
var active_duration: float = flight_duration
var exploded: bool = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _initilise() -> void:
	velocity = ability_base.muzzle.global_position.direction_to(ability_base.target_point) * speed

func _physics_process(delta: float) -> void:
	active_duration -= delta
	if active_duration <= 0.0:
		queue_free()
	
	if not exploded and not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()

func _on_contact(_body: Node3D) -> void:
	explosion_area.visible = true
	explosion_area.monitoring = true
	exploded = true
	active_duration = explosion_duration
	velocity = Vector3.ZERO

func _on_explosion(body: Node3D) -> void:
	ability_base._on_hit(body)

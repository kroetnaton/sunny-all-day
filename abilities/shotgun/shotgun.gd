extends Node3D

@onready var ability_base: AbilityBase = $AbilityBase
@onready var circle_spawner: CircleSpawner = $CircleSpawner
@onready var target_spawner: CircleSpawner = $TargetSpawner

@export var pellets: int = 9
@export var spread: float = 0.5

func _initilise() -> void:
	look_at(ability_base.target_point)
	circle_spawner.initiate(pellets, 2 * PI, 0.2)
	target_spawner.initiate(pellets, 2 * PI, spread)
	while target_spawner.has_spawn_next() and circle_spawner.has_spawn_next():
		var target: Node3D = target_spawner.spawn_next(Vector3.FORWARD, true)
		var bullet: Bullet = circle_spawner.spawn_next(ability_base.target_point)
		bullet.hit.connect(ability_base._on_hit)
		bullet._initilise(bullet.global_position.direction_to(target.global_position))
		target.queue_free()

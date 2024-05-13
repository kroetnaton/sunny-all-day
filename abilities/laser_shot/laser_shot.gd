extends Node3D

@onready var ability_base: AbilityBase = $AbilityBase
@onready var circle_spawner: CircleSpawner = $CircleSpawner

@export var beams: int = 1
var lasers: Array[Laser] = []

func _initilise() -> void:
	circle_spawner.initiate(beams)
	while circle_spawner.has_spawn_next():
		var laser: Laser = circle_spawner.spawn_next(ability_base.target_point)
		laser.hit.connect(ability_base._on_hit)
		lasers.append(laser)

func _process(_delta: float) -> void:
	for laser: Laser in lasers:
		if is_instance_valid(laser):
			return
	queue_free()

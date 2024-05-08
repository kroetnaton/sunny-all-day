extends Node3D

@onready var ability_base: AbilityBase = $AbilityBase
@onready var circle_spawner: CircleSpawner = $CircleSpawner

@export var beams: int = 18
var lasers: Array[Laser] = []

func _initilise() -> void:
	if not is_instance_valid(ability_base.target_object) or \
			not "life_controller" in ability_base.target_object:
		ability_base.cooldown = 0.0
		queue_free()
		return
	global_position = ability_base.target_object.global_position
	circle_spawner.initiate(beams, 2 * PI)
	while circle_spawner.has_spawn_next():
		var laser: Laser = circle_spawner.spawn_next(Vector3.DOWN, true)
		laser.hit.connect(ability_base._on_hit)
		lasers.append(laser)

func _process(delta: float) -> void:
	for laser: Laser in lasers:
		if is_instance_valid(laser):
			return
	queue_free()

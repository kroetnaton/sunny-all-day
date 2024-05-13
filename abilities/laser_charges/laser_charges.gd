extends Node3D

@onready var laser_resource: Resource = AbilityPartLoader.preload_dict[Enums.Parts.Laser]
@onready var ability_base: AbilityBase = $AbilityBase
@onready var circle_spawner: CircleSpawner = $CircleSpawner

@export var max_beam_cooldown: float = 0.2
var actual_beam_cooldown: float
@export var beams: int = 9

var duration: float
var beam_cooldown: float
var lasers: Array[Laser] = []

func _initilise() -> void:
	circle_spawner.initiate(beams)
	duration = ability_base.cooldown
	actual_beam_cooldown = min(max_beam_cooldown, ability_base.cooldown / beams)

func _process(delta: float) -> void:
	if is_instance_valid(ability_base.muzzle):
		global_transform = ability_base.muzzle.global_transform
	
	if duration < 0.0:
		for laser: Laser in lasers:
			if is_instance_valid(laser):
				return
		queue_free()
		return
	else:
		beam_cooldown -= delta
		duration -= delta

func _recast(ability_base_temp: AbilityBase):
	if duration < 0.0 or beam_cooldown > 0.0:
		return
	
	for i: int in round(1 + beam_cooldown / actual_beam_cooldown * -1):
		if circle_spawner.has_spawn_next():
			var laser: Laser = circle_spawner.spawn_next(ability_base_temp.target_point)
			laser.hit.connect(ability_base._on_hit)
			lasers.append(laser)
			beam_cooldown += actual_beam_cooldown

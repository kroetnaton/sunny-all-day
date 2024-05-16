extends Node3D

@onready var ability_base: AbilityBase = $AbilityBase
@onready var path: Path3D = $Path3D
@onready var laser_resource: Resource = AbilityPartLoader.preload_dict[Enums.Parts.Laser]

@export var duration_between_hits: float = 0.05
@export var beams: int = 10
var duration_between_lasers: float
var current_duration: float
var current_beam: int = 0
var laser_duration: float

var path_followers: Array[PathFollow3D] = []

func _ready() -> void:
	var laser: Laser = create_laser()
	laser_duration = laser.duration
	duration_between_lasers = laser.duration_after_fire + duration_between_hits
	current_duration = duration_between_lasers

func _process(delta: float) -> void:
	if current_beam == beams:
		var free: bool = true
		for follower in path_followers:
			if is_instance_valid(follower):
				free = false
				break
		if free:
			queue_free()
	else:
		current_duration -= delta
		if current_duration < 0.0:
			create_laser()
	
	if is_instance_valid(ability_base.muzzle):
		global_position = ability_base.muzzle.global_position
	if is_instance_valid(ability_base.aim_point):
		look_at(ability_base.aim_point.global_position)
	
	for follower in path_followers:
		if is_instance_valid(follower):
			follower.progress_ratio = min(follower.progress_ratio + delta / laser_duration, 1.0)

func create_laser() -> Laser:
	var path_follower: PathFollow3D = PathFollow3D.new()
	path_follower.rotation_mode = PathFollow3D.ROTATION_NONE
	var laser: Laser = laser_resource.instantiate()
	laser.hit.connect(ability_base._on_hit)
	laser.tree_exiting.connect(path_follower.queue_free)
	path_follower.add_child(laser)
	path.add_child(path_follower)
	path_followers.append(path_follower)
	current_beam += 1
	current_duration = duration_between_lasers
	return laser

extends Node3D

@onready var ability_base: AbilityBase = $AbilityBase
@onready var bullet: Bullet = $Bullet

func _initilise() -> void:
	bullet._initilise(ability_base.muzzle.global_position.direction_to(ability_base.target_point))

func _process(_delta: float) -> void:
	if not is_instance_valid(bullet):
		queue_free()

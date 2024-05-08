extends Node3D

@onready var ability_base: AbilityBase = $AbilityBase

func _process(_delta: float) -> void:
	if not is_instance_valid(ability_base.controller):
		queue_free()
		return
	ability_base.controller.set_time(ability_base.slot, 1.0)

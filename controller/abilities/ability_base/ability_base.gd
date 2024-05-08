extends Node3D
class_name AbilityBase

var parent: Node3D
var controller: AbilityController
var muzzle: Marker3D
var aim_point: Marker3D
var slot: Dictionary
var is_target_collision: bool
var target_point: Vector3
var target_object: Object

@export var cooldown: float = 3.0
@export var damage: float = 10.0

func _on_hit(body: Node3D) -> void:
	if not is_instance_valid(body):
		return
	
	if "life_controller" in body:
		var life_controller: LifeController = body.life_controller
		life_controller.damage.append(damage)

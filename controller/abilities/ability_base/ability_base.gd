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

@export var ability_name: String
@export var cooldown: float = 3.0
@export var duration: float = 0.0

@export var damage: float = 0.0
@export var dot: float = 0.0
@export var damage_block_percent: float = 0.0
@export var damage_boost_percent: float = 0.0
@export var damage_block_flat: float = 0.0
@export var damage_boost_flat: float = 0.0
@export var heal: float = 0.0
@export var hot: float = 0.0
@export var heal_block_percent: float = 0.0
@export var heal_boost_percent: float = 0.0
@export var heal_block_flat: float = 0.0
@export var heal_boost_flat: float = 0.0

func _on_hit(body: Node3D) -> void:
	if not is_instance_valid(body):
		return
	
	if "life_controller" in body:
		var life_controller: LifeController = body.life_controller
		life_controller.damage_list.append(damage)
		life_controller.add_damage_changes(ability_name, duration, dot,
				damage_block_percent, damage_boost_percent, damage_block_flat, damage_boost_flat)
		life_controller.heal_list.append(heal)
		life_controller.add_heal_changes(ability_name, duration, hot,
				heal_block_percent, heal_boost_percent, heal_block_flat, heal_boost_flat)

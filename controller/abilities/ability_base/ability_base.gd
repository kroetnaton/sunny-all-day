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
@export var force_movement: Vector3 = Vector3.ZERO
@export var speed_factor: float = 1.0
@export var fall_factor: float = 1.0
@export var disable_jump: bool = false
@export var added_jumps: int = 0
@export var affects_primary: bool = false
@export var affects_secondary: bool = false
@export var affects_utility: bool = false
@export var affects_special: bool = false
@export var disable_ability: bool = false
@export var ability_cooldown_factor: float = 1.0

@onready var ability_name: String = get_parent().name
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
	if "movement_controller" in body:
		var movement_controller: MovementController = body.movement_controller
		movement_controller.add_movement_effect(ability_name, duration, force_movement, speed_factor, fall_factor,
				disable_jump, added_jumps)
	if "ability_controller" in body:
		var ability_controller: AbilityController = body.ability_controller
		if affects_primary:
			ability_controller.add_ability_effect(Enums.AbilitySlot.Primary, ability_name, duration, disable_ability, ability_cooldown_factor)
		if affects_secondary:
			ability_controller.add_ability_effect(Enums.AbilitySlot.Secondary, ability_name, duration, disable_ability, ability_cooldown_factor)
		if affects_utility:
			ability_controller.add_ability_effect(Enums.AbilitySlot.Utility, ability_name, duration, disable_ability, ability_cooldown_factor)
		if affects_special:
			ability_controller.add_ability_effect(Enums.AbilitySlot.Special, ability_name, duration, disable_ability, ability_cooldown_factor)

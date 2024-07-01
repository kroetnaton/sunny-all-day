extends Node3D
class_name AbilityBase

var parent: Node3D
var controller: AbilityController
var muzzle: Marker3D
var aim_point: Marker3D
var slot: AbilityController.SlotData
var is_target_collision: bool
var target_point: Vector3
var target_object: Object

@onready var ability_name: String = get_parent().name
@export_multiline var description: String = "":
	get:
		var value: String = ability_name + "\n\n" + \
				description +  \
				"\n\nCooldown: " + str(cooldown) + "s" + \
				("\nDamage: " + str (damage) if damage != 0.0 else "") + \
				("\nHeal: " + str (heal) if heal != 0.0 else "")
		if duration != 0.0:
			var duration_text: String = " " + str(duration) + "s"
			value += ("\nDamage over time: " + str(dot / duration) + " DPS (" + str(dot) + " in" + duration_text + ")" if dot != 0.0 else "") + \
					("\nIncreased damage per hit: " + str(damage_boost_flat - damage_block_flat) + " for" + duration_text if damage_boost_flat + damage_block_flat != 0.0 else "") + \
					("\nDamage reduction: " + str(damage_block_percent * 100) + "% for" + duration_text if damage_block_percent != 0.0 else "") + \
					("\nDamage amplification: " + str(damage_boost_percent * 100) + "% for" + duration_text if damage_boost_percent != 0.0 else "") + \
					("\nHeal over time: " + str(hot / duration) + " HPS (" + str(hot) + " in" + duration_text + ")" if dot != 0.0 else "") + \
					("\nIncreased heal per hit: " + str(heal_boost_flat - heal_block_flat) + " for" + duration_text if heal_boost_flat + heal_block_flat != 0.0 else "") + \
					("\nHeal reduction: " + str(heal_block_percent * 100) + "% for" + duration_text if heal_block_percent != 0.0 else "") + \
					("\nHeal amplification: " + str(heal_boost_percent * 100) + "% for" + duration_text if heal_boost_percent != 0.0 else "")
		return value

@export var cooldown: float = 3.0
@export var duration: float = 0.0

@export_group("Health Changes")
@export_subgroup("Damage")
@export var damage: float = 0.0
@export var dot: float = 0.0
@export var damage_block_percent: float = 0.0
@export var damage_boost_percent: float = 0.0
@export var damage_block_flat: float = 0.0
@export var damage_boost_flat: float = 0.0
@export_subgroup("Heal")
@export var heal: float = 0.0
@export var hot: float = 0.0
@export var heal_block_percent: float = 0.0
@export var heal_boost_percent: float = 0.0
@export var heal_block_flat: float = 0.0
@export var heal_boost_flat: float = 0.0
@export_group("Movement")
@export var force_movement: Vector3 = Vector3.ZERO
@export var speed_factor: float = 1.0
@export var fall_factor: float = 1.0
@export_subgroup("Jumps")
@export var disable_jump: bool = false
@export var added_jumps: int = 0
@export_group("Abilities")
@export_flags("Primary", "Secondary", "Utility", "Special") var affected_abilities: int = 0
@export var disable_ability: bool = false
@export var ability_cooldown_factor: float = 1.0

var slot_flags: Dictionary = {
	Enums.AbilitySlot.Primary: 1 << 0,
	Enums.AbilitySlot.Secondary: 1 << 1,
	Enums.AbilitySlot.Utility: 1 << 2,
	Enums.AbilitySlot.Special: 1 << 3,
}

func _on_hit(body: Node3D) -> void:
	if not is_instance_valid(body):
		return
	
	if "life_controller" in body:
		var life_controller: LifeController = body.life_controller
		life_controller.damage_list.append(damage)
		life_controller.add_damage_effect(ability_name, duration, dot,
				damage_block_percent, damage_boost_percent, damage_block_flat, damage_boost_flat)
		life_controller.heal_list.append(heal)
		life_controller.add_heal_effect(ability_name, duration, hot,
				heal_block_percent, heal_boost_percent, heal_block_flat, heal_boost_flat)
	if "movement_controller" in body:
		var movement_controller: MovementController = body.movement_controller
		movement_controller.add_movement_effect(ability_name, duration, force_movement, speed_factor, fall_factor,
				disable_jump, added_jumps)
	if "ability_controller" in body:
		var ability_controller: AbilityController = body.ability_controller
		for key: Enums.AbilitySlot in slot_flags:
			if slot_flags[key] & affected_abilities:
				ability_controller.add_ability_effect(key, ability_name, duration, disable_ability, ability_cooldown_factor)

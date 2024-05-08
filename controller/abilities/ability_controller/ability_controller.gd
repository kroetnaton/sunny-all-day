extends Node3D
class_name AbilityController

signal primary_recast(ability_base: AbilityBase)
signal primary_uncast(ability_base: AbilityBase)
signal secondary_recast(ability_base: AbilityBase)
signal secondary_uncast(ability_base: AbilityBase)
signal utility_recast(ability_base: AbilityBase)
signal utility_uncast(ability_base: AbilityBase)
signal special_recast(ability_base: AbilityBase)
signal special_uncast(ability_base: AbilityBase)

@onready var parent: Node3D = get_parent()
@onready var muzzle: Marker3D = $Muzzle
@onready var ray_cast: RayCast3D = $RayCast3D
@onready var spring_arm_marker: Marker3D = $SpringArm3D/Marker3D

@export var cooldown_hud: CooldownHud

@onready var ability_slot_dict: Dictionary = {
	Enums.AbilitySlot.Primary: {"ability":Enums.Ability.Nothing, "slot":Enums.AbilitySlot.Primary, "timer":0.0, "recast":primary_recast, "uncast":primary_uncast},
	Enums.AbilitySlot.Secondary: {"ability":Enums.Ability.Nothing, "slot":Enums.AbilitySlot.Secondary, "timer":0.0, "recast":secondary_recast, "uncast":secondary_uncast},
	Enums.AbilitySlot.Utility: {"ability":Enums.Ability.Nothing, "slot":Enums.AbilitySlot.Utility, "timer":0.0, "recast":utility_recast, "uncast":utility_uncast},
	Enums.AbilitySlot.Special: {"ability":Enums.Ability.Nothing, "slot":Enums.AbilitySlot.Special, "timer":0., "recast":special_recast, "uncast":special_uncast},
}

func _process(delta: float) -> void:
	for slot in ability_slot_dict:
		if Enums.Ability.Nothing == ability_slot_dict[slot]["ability"]:
			cast(slot)
		var slot_dict: Dictionary = ability_slot_dict[slot]
		if slot_dict["timer"] > 0.0:
			slot_dict["timer"] -= delta
			var cooldown_visual: CooldownVisual = cooldown_hud.cooldown_visual_dict[slot]
			cooldown_visual.set_current(slot_dict["timer"])

func set_ability(ability: Enums.Ability, slot: Enums.AbilitySlot) -> void:
	ability_slot_dict[slot]["ability"] = ability

func cast(slot: Enums.AbilitySlot) -> void:
	var slot_dict: Dictionary = ability_slot_dict[slot]
	emit_signal(slot_dict["recast"].get_name(), create_ability_base(slot_dict))
	if slot_dict["timer"] > 0.0:
		return
	var ability: Node3D = instantiate_scene(slot_dict)
	set_time(slot_dict, ability.ability_base.cooldown)

func uncast(slot: Enums.AbilitySlot) -> void:
	var slot_dict: Dictionary = ability_slot_dict[slot]
	emit_signal(slot_dict["uncast"].get_name(), create_ability_base(slot_dict))

func set_time(slot_dict: Dictionary, time: float) -> void:
	slot_dict["timer"] = time
	var visual: CooldownVisual = cooldown_hud.cooldown_visual_dict[slot_dict["slot"]]
	visual.set_cooldown(time)

func instantiate_scene(slot_dict: Dictionary) -> Node3D:
	var node: Node3D = AbilitySceneLoader.preload_dict[slot_dict["ability"]].instantiate()
	parent.add_sibling(node)
	node.global_transform = muzzle.global_transform
	set_ability_base(node.ability_base, slot_dict)
	if node.has_method("_recast"):
		slot_dict["recast"].connect(node._recast)
	if node.has_method("_uncast"):
		slot_dict["uncast"].connect(node._uncast)
	if node.has_method("_initilise"):
		node._initilise()
	return node

func create_ability_base(slot_dict: Dictionary) -> AbilityBase:
	var ability_base: AbilityBase = AbilityBase.new()
	set_ability_base(ability_base, slot_dict)
	return ability_base

func set_ability_base(ability_base: AbilityBase, slot_dict: Dictionary) -> void:
	ability_base.parent = parent
	ability_base.controller = self
	ability_base.muzzle = muzzle
	ability_base.aim_point = spring_arm_marker
	ability_base.slot = slot_dict
	ability_base.is_target_collision = ray_cast.is_colliding()
	if ray_cast.is_colliding():
		ability_base.target_point = ray_cast.get_collision_point()
	else:
		ability_base.target_point = spring_arm_marker.global_position
	ability_base.target_object = ray_cast.get_collider()

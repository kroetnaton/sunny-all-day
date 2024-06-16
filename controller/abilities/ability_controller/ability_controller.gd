extends Node3D
class_name AbilityController

signal time_set(slot: Enums.AbilitySlot, time: float)
signal time_change(slot: Enums.AbilitySlot, time: float)

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

@onready var ability_slot_dict: Dictionary = {
	Enums.AbilitySlot.Primary: SlotData.new(Enums.Ability.Nothing, Enums.AbilitySlot.Primary, 0.0, primary_recast, primary_uncast),
	Enums.AbilitySlot.Secondary: SlotData.new(Enums.Ability.Nothing, Enums.AbilitySlot.Secondary, 0.0, secondary_recast, secondary_uncast),
	Enums.AbilitySlot.Utility: SlotData.new(Enums.Ability.Nothing, Enums.AbilitySlot.Utility, 0.0, utility_recast, utility_uncast),
	Enums.AbilitySlot.Special: SlotData.new(Enums.Ability.Nothing, Enums.AbilitySlot.Special, 0.0, special_recast, special_uncast),
}

var effects_container: Dictionary = {
	Enums.AbilitySlot.Primary: {},
	Enums.AbilitySlot.Secondary: {},
	Enums.AbilitySlot.Utility: {},
	Enums.AbilitySlot.Special: {},
}

func _process(delta: float) -> void:
	for slot: Enums.AbilitySlot in ability_slot_dict:
		var slot_data: SlotData = ability_slot_dict[slot]
		if Enums.Ability.Nothing == slot_data.ability:
			cast(slot)
		if slot_data.timer > 0.0:
			slot_data.timer -= delta * get_cooldown_factor(slot)
			time_change.emit(slot, slot_data.timer)
		var dict: Dictionary = effects_container[slot]
		for key: String in dict:
			var entry: AbilityEffect = dict[key]
			if entry.duration < 0.0:
				dict.erase(key)
			else:
				entry.duration -= delta

func set_ability(ability: Enums.Ability, slot: Enums.AbilitySlot) -> void:
	ability_slot_dict[slot].ability = ability

func cast(slot: Enums.AbilitySlot) -> void:
	if is_disabled(slot):
		return
	var slot_data: SlotData = ability_slot_dict[slot]
	slot_data.recast.emit(create_ability_base(slot_data))
	if slot_data.timer > 0.0:
		return
	var ability: Node3D = instantiate_scene(slot_data)
	set_time(slot_data, ability.ability_base.cooldown)

func uncast(slot: Enums.AbilitySlot) -> void:
	var slot_data: SlotData = ability_slot_dict[slot]
	slot_data.uncast.emit(create_ability_base(slot_data))

func add_ability_effect(slot: Enums.AbilitySlot, effect_name: String, duration: float,
		disabled: bool = false, cooldown_factor: float = 1.0) -> void:
	effects_container[slot][effect_name] = AbilityEffect.new(duration, disabled, cooldown_factor)

func get_cooldown_factor(slot: Enums.AbilitySlot) -> float:
	var cooldown_factor: float = 1.0
	var dict: Dictionary = effects_container[slot]
	for key: String in dict:
		cooldown_factor *= dict[key].cooldown_factor
	return cooldown_factor

func is_disabled(slot: Enums.AbilitySlot) -> bool:
	var disabled: bool = false
	var dict: Dictionary = effects_container[slot]
	for key: String in dict:
		disabled = disabled || dict[key].disabled
	return disabled

func set_time(slot_data: SlotData, time: float) -> void:
	slot_data.timer = time
	time_set.emit(slot_data.slot, time)

func instantiate_scene(slot_data: SlotData) -> Node3D:
	var node: Node3D = AbilitySceneLoader.preload_dict[slot_data.ability].instantiate()
	parent.add_sibling(node)
	node.global_transform = muzzle.global_transform
	set_ability_base(node.ability_base, slot_data)
	if node.has_method("_recast"):
		slot_data.recast.connect(node._recast)
	if node.has_method("_uncast"):
		slot_data.uncast.connect(node._uncast)
	if node.has_method("_initilise"):
		node._initilise()
	return node

func create_ability_base(slot_data: SlotData) -> AbilityBase:
	var ability_base: AbilityBase = AbilityBase.new()
	set_ability_base(ability_base, slot_data)
	return ability_base

func set_ability_base(ability_base: AbilityBase, slot_data: SlotData) -> void:
	ability_base.parent = parent
	ability_base.controller = self
	ability_base.muzzle = muzzle
	ability_base.aim_point = spring_arm_marker
	ability_base.slot = slot_data
	ability_base.is_target_collision = ray_cast.is_colliding()
	if ray_cast.is_colliding():
		ability_base.target_point = ray_cast.get_collision_point()
	else:
		ability_base.target_point = spring_arm_marker.global_position
	ability_base.target_object = ray_cast.get_collider()

class SlotData:
	var ability: Enums.Ability = Enums.Ability.Nothing
	var slot: Enums.AbilitySlot = Enums.AbilitySlot.Primary
	var timer: float = 0.0
	var recast: Signal
	var uncast: Signal
	func _init(ability_i: Enums.Ability, slot_i: Enums.AbilitySlot, timer_i: float,
			recast_i: Signal, uncast_i: Signal) -> void:
		ability = ability_i
		slot = slot_i
		timer = timer_i
		recast = recast_i
		uncast = uncast_i

class AbilityEffect:
	var duration: float = 0.0
	var disabled: bool = false
	var cooldown_factor: float = 1.0
	func _init(duration_i: float, disabled_i: bool, cooldown_factor_i: float) -> void:
		duration = duration_i
		disabled = disabled_i
		cooldown_factor = cooldown_factor_i

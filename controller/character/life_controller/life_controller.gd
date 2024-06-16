extends Node3D
class_name LifeController

signal death
signal max_health_change(max_health: float)
signal health_change(health: float)

@export var max_health: float = 100.0:
	set(change):
		max_health = change
		max_health_change.emit(max_health)
@onready var health: float = max_health:
	set(change):
		health = change
		health_change.emit(health)

var damage_list: Array = []
var dot_container: Dictionary = {}
var heal_list: Array = []
var hot_container: Dictionary = {}

func add_damage_effect(effect_name: String, duration: float = 0.0, change: float = 0.0, block_percent: float = 0.0,
		boost_percent: float = 0.0, block_flat: float = 0.0, boost_flat: float = 0.0) -> void:
	add_values(dot_container, effect_name, duration, change, block_percent, boost_percent, block_flat, boost_flat)

func add_heal_effect(effect_name: String, duration: float = 0.0, change: float = 0.0, block_percent: float = 0.0,
		boost_percent: float = 0.0, block_flat: float = 0.0, boost_flat: float = 0.0) -> void:
	add_values(hot_container, effect_name, duration, change, block_percent, boost_percent, block_flat, boost_flat)

func _process(delta: float) -> void:
	health += sum_and_clean_values(heal_list, hot_container, delta) - \
			sum_and_clean_values(damage_list, dot_container, delta)
	if health <= 0.0:
		death.emit()

func add_values(dict: Dictionary, effect_name: String, duration: float, change: float, block_percent: float,
		boost_percent: float, block_flat: float, boost_flat: float) -> void:
	dict[effect_name] = LifeEffect.new(duration, change, block_percent, boost_percent, block_flat, boost_flat)

func sum_and_clean_values(list: Array, dict: Dictionary, delta: float) -> float:
	var change: float = 0.0
	var block_percent: float = 0.0
	var boost_percent: float = 0.0
	var block_flat: float = 0.0
	var boost_flat: float = 0.0
	
	var count: int = 0
	for key: String in dict:
		var entry: LifeEffect = dict[key]
		if entry.duration < 0.0:
			dict.erase(key)
		else:
			entry.duration -= delta
		
		if entry.change > 0.0:
			count += 1
			change += entry.change * min(delta, entry.duration)
		
		block_percent += (1 - block_percent) * max(0.0, entry.block_percent)
		boost_percent += (1 - block_percent) * max(0.0, entry.boost_percent)
		block_flat += max(0.0, entry.block_flat)
		boost_flat += max(0.0, entry.boost_flat)
	change += (boost_flat - block_flat) * count * delta
	
	for value: float in list:
		if value > 0.0:
			change += value + boost_flat - block_flat
	list.clear()
	
	return max(0.0, change * (1 - block_percent) * (1 + boost_percent))

class LifeEffect:
	var duration: float = 0.0
	var change: float = 0.0
	var block_percent: float = 0.0
	var boost_percent: float = 0.0
	var block_flat: float = 0.0
	var boost_flat: float = 0.0
	func _init(duration_i: float, change_i: float, block_percent_i: float,
			boost_percent_i: float, block_flat_i: float, boost_flat_i: float) -> void:
		duration = duration_i
		change = change_i
		block_percent = block_percent_i
		boost_percent = boost_percent_i
		block_flat = block_flat_i
		boost_flat = boost_flat_i

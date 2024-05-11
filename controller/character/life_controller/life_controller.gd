extends Node3D
class_name LifeController

@export var max_health: float = 100.0
@onready var health: float = max_health
@export var life_hud: LifeHud

var damage_list: Array = []
var dot_container: Dictionary = {}
var heal_list: Array = []
var hot_container: Dictionary = {}

func add_damage_changes(name: String, duration: float = 0.0, change: float = 0.0, block_percent: float = 0.0,
		boost_percent: float = 0.0, block_flat: float = 0.0, boost_flat: float = 0.0) -> void:
	add_values(dot_container, name, duration, change, block_percent, boost_percent, block_flat, boost_flat)

func add_heal_changes(name: String, duration: float = 0.0, change: float = 0.0, block_percent: float = 0.0,
		boost_percent: float = 0.0, block_flat: float = 0.0, boost_flat: float = 0.0) -> void:
	add_values(hot_container, name, duration, change, block_percent, boost_percent, block_flat, boost_flat)

func _process(delta: float) -> void:
	health += sum_and_clean_values(heal_list, hot_container, delta) - \
			sum_and_clean_values(damage_list, dot_container, delta)
	if health <= 0.0:
		get_parent().queue_free()
	
	# Update visual
	if is_instance_valid(life_hud):
		life_hud.health_bar.max_value = max_health
		life_hud.health_bar.value = health

func add_values(dict: Dictionary, name: String, duration: float, change: float, block_percent: float,
		boost_percent: float, block_flat: float, boost_flat: float) -> void:
	dict[name] = {
			"duration": duration, "change": change,
			"block_percent": block_percent, "boost_percent": boost_percent,
			"block_flat": block_flat, "boost_flat": boost_flat}

func sum_and_clean_values(list: Array, dict: Dictionary, delta: float) -> float:
	var change: float = 0.0
	var block_percent: float = 0.0
	var boost_percent: float = 0.0
	var block_flat: float = 0.0
	var boost_flat: float = 0.0
	
	var count: int = 0
	for key: String in dict:
		var entry: Dictionary = dict[key]
		if entry["duration"] < 0.0:
			dict.erase(key)
		else:
			entry["duration"] -= delta
		
		if entry["change"] > 0.0:
			count += 1
			change += entry["change"] * min(delta, entry["duration"])
		
		block_percent += (1 - block_percent) * max(0.0, entry["block_percent"])
		boost_percent += (1 - block_percent) * max(0.0, entry["boost_percent"])
		block_flat += max(0.0, entry["block_flat"])
		boost_flat += max(0.0, entry["boost_flat"])
	change += (boost_flat - block_flat) * count * delta
	
	for value: float in list:
		if value > 0.0:
			change += value + boost_flat - block_flat
	list.clear()
	
	return max(0.0, change * (1 - block_percent) * (1 + boost_percent))

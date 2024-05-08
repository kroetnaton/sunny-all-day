extends Node3D
class_name LifeController

@export var max_health: float = 100.0
@onready var health: float = max_health
@export var life_hud: LifeHud

var damage: Array = []
var damage_block_flat: float = 0.0
var damage_block_percent: float = 0.0:
	set(change):
		add_percentage_change(damage_block_percent, change)

var heal: Array = []
var heal_boost_flat: float = 0.0
var heal_boost_percent: float = 0.0:
	set(change):
		add_percentage_change(heal_boost_percent, change)

func _process(_delta: float) -> void:
	var final_damage: float = 0.0
	for damage_instance in damage:
		final_damage += max(damage_instance * (1 - damage_block_percent) - damage_block_flat, 0.0)
	
	var final_heal: float = 0.0
	for heal_instance: float in heal:
		final_heal += max(heal_instance * (1 + heal_boost_percent) + heal_boost_flat, 0.0)
	
	health += final_heal - final_damage
	if health <= 0.0:
		get_parent().queue_free()
	
	# Update visual
	if is_instance_valid(life_hud):
		life_hud.health_bar.max_value = max_health
		life_hud.health_bar.value = health
	
	# Reset values for the next tick
	damage = []
	damage_block_flat = 0.0
	damage_block_percent = -1.0 # To reset through the setter
	heal = []
	heal_boost_flat = 0.0
	heal_boost_percent = -1.0 # To reset through the setter

func add_percentage_change(current: float, change: float) -> float:
	if change > 1.0:
		return 1.0
	if change < 0.0:
		return 0.0
	return current + (1 - current) * change

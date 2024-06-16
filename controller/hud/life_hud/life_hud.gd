extends Node3D
class_name LifeHud

@onready var health_bar: ProgressBar = $SubViewport/HealthBar

func _on_max_health_change(max_health: float) -> void:
	health_bar.max_value = max_health

func _on_health_change(health: float) -> void:
	health_bar.value = health

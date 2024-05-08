extends Node3D
class_name Laser

signal hit(body: Object)

@export var duration: float = 1.0
@export var duration_after_fire: float = 0.1
@export var length: float = 30:
	set(value):
		raycast.target_position = Vector3.FORWARD * value

@onready var origin: Marker3D = $Origin
@onready var laser_visual: MeshInstance3D = $Origin/LaserVisual
@onready var laser_end_visual: MeshInstance3D = $Origin/LaserEndVisual
@onready var raycast: RayCast3D = $Origin/RayCast3D

var fired: bool = false

func _process(delta):
	duration -= delta
	if duration <= 0.0:
		if fired:
			queue_free()
		else:
			fired = true
			duration = duration_after_fire
			laser_end_visual.show_fired(
				global_position.distance_to(raycast.get_collision_point()) if raycast.is_colliding() else length)
			laser_visual.visible = false
			emit_signal("hit", raycast.get_collider())

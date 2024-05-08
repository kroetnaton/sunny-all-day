extends CharacterBody3D
class_name Bullet

signal hit(body: Object)

@export var speed: float = 30.0
@export var life_time: float = 2.0

func _initilise(direction: Vector3) -> void:
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	life_time -= delta
	if life_time <= 0.0:
		queue_free()
		return
	
	if get_slide_collision_count() != 0:
		for i: int in get_slide_collision_count():
			emit_signal("hit", get_slide_collision(i).get_collider())
		queue_free()
		return
	
	move_and_slide()

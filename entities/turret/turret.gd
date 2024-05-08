extends Node3D

@onready var life_controller: LifeController = $LifeController
@onready var ability_controller: AbilityController = $HeadCollision/Head/AbilityController
@onready var movement_controller: MovementController = $MovementController

@onready var head: CollisionShape3D = $HeadCollision

var target: Node3D
@export var ability: Enums.Ability = Enums.Ability.MachineGun

func _ready() -> void:
	ability_controller.parent = self
	ability_controller.set_ability(ability, Enums.AbilitySlot.Primary)

func _on_aggro_area_body_entered(body: Node3D) -> void:
	if target == null:
		target = body

func _process(_delta: float) -> void:
	if target == null:
		pass
	else:
		head.look_at(target.global_position)
		ability_controller.cast(Enums.AbilitySlot.Primary)

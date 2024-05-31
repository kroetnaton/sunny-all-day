extends Node3D

@onready var life_controller: LifeController = $LifeController
@onready var ability_controller: AbilityController = $HeadCollision/Head/AbilityController
@onready var movement_controller: MovementController = $MovementController
@onready var aggro_controller: AggroController = $HeadCollision/Head/AggroController

@onready var head: CollisionShape3D = $HeadCollision

@export var ability: Enums.Ability = Enums.Ability.MachineGun

func _ready() -> void:
	ability_controller.parent = self
	ability_controller.set_ability(ability, Enums.AbilitySlot.Primary)

func _process(_delta: float) -> void:
	if aggro_controller.target == null:
		pass
	else:
		head.look_at(aggro_controller.target.global_position)
		ability_controller.cast(Enums.AbilitySlot.Primary)

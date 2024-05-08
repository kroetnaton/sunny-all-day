extends CharacterBody3D

@export var sensitivity: float = 0.1

@onready var pivot: Node3D = $ViewPivot
@onready var life_controller: LifeController = $LifeController
@onready var movement_controller: MovementController = $MovementController
@onready var ability_controller: AbilityController = $ViewPivot/SpringArm3D/Camera3D/AbilityController

@export var primary: Enums.Ability
@export var secondary: Enums.Ability
@export var utility: Enums.Ability
@export var special: Enums.Ability

var ability_slot_dict: Dictionary = {
	Enums.AbilitySlot.Primary:"Primary",
	Enums.AbilitySlot.Secondary:"Secondary",
	Enums.AbilitySlot.Utility:"Utility",
	Enums.AbilitySlot.Special:"Special",
}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ability_controller.parent = self
	ability_controller.muzzle = $Pivot/Muzzle
	ability_controller.set_ability(primary, Enums.AbilitySlot.Primary)
	ability_controller.set_ability(secondary, Enums.AbilitySlot.Secondary)
	ability_controller.set_ability(utility, Enums.AbilitySlot.Utility)
	ability_controller.set_ability(special, Enums.AbilitySlot.Special)

func _input(event) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		pivot.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		pivot.rotation.x = clamp(pivot.rotation.x, -PI/2 + PI/6, PI/4)

func _process(_delta) -> void:
	for slot in ability_slot_dict:
		var input_action: String = ability_slot_dict[slot]
		if Input.is_action_pressed(input_action):
			ability_controller.cast(slot)
		if Input.is_action_just_released(input_action):
			ability_controller.uncast(slot)
	
	var input: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	movement_controller.move_direction(Vector3(input.x, 0, input.y))
	if Input.is_action_pressed("Jump"):
		movement_controller.jump()
	
	if position.y < -20:
		position = Vector3.ZERO

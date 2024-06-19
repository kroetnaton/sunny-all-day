extends VBoxContainer
class_name SlotButton

signal pressed(slot: Enums.AbilitySlot)

@onready var label: Label = $Label
@onready var button: Button = $Button

@onready var slot: Enums.AbilitySlot = Enums.AbilitySlot.Primary
@onready var ability: Enums.Ability = Enums.Ability.Nothing:
	set(change):
		ability = change
		button.text = Enums.Ability.find_key(ability)
@onready var comb_size: Vector2:
	set(change):
		comb_size = change
		button.custom_minimum_size = comb_size - (label.size + Vector2(0, 10))

func _initilise(i_slot: Enums.AbilitySlot, i_comb_size: Vector2) -> void:
	slot = i_slot
	label.text = Enums.AbilitySlot.find_key(slot)
	ability = Enums.Ability.Nothing
	comb_size = i_comb_size

func _on_button_pressed():
	pressed.emit(slot)

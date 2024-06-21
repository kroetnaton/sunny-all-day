extends PanelContainer
class_name SlotButton

signal pressed(slot: Enums.AbilitySlot)

@export var selected_style: StyleBoxFlat

@onready var label: Label = $VBoxContainer/Label
@onready var button: Button = $VBoxContainer/Button

@onready var slot: Enums.AbilitySlot = Enums.AbilitySlot.Primary:
	set(change):
		slot = change
		label.text = Enums.AbilitySlot.find_key(slot)
@onready var ability: Enums.Ability = Enums.Ability.Nothing:
	set(change):
		ability = change
		button.text = Enums.Ability.find_key(ability)
@onready var comb_size: Vector2:
	set(change):
		comb_size = change
		button.custom_minimum_size = comb_size - (label.size + Vector2(0, 10))

func _initilise(i_slot: Enums.AbilitySlot, i_ability: Enums.Ability, i_comb_size: Vector2) -> void:
	slot = i_slot
	ability = i_ability
	comb_size = i_comb_size

func _on_button_pressed() -> void:
	pressed.emit(slot)

func _on_select(affected_slot: Enums.AbilitySlot) -> void:
	if affected_slot != slot:
		remove_theme_stylebox_override("panel")
	else:
		add_theme_stylebox_override("panel", selected_style)

func _on_ability_change(affected_slot: Enums.AbilitySlot, changed_ability: Enums.Ability) -> void:
	if affected_slot == slot:
		ability = changed_ability

extends Node2D

signal select(unaffected_slot: Enums.AbilitySlot)
signal ability_change(slot: Enums.AbilitySlot, ability: Enums.Ability)

@onready var base: PanelContainer = $PanelContainer
@onready var ability_container: ScrollContainer = $PanelContainer/ScrollContainer
@onready var ability_grid_container: GridContainer = $PanelContainer/ScrollContainer/GridContainer

@onready var bottom_container: VBoxContainer = $PanelContainer/VBoxContainer
@onready var slot_button_container: GridContainer = $PanelContainer/VBoxContainer/SlotButtonContainer
@onready var bottom_button_container: PanelContainer = $PanelContainer/VBoxContainer/PanelContainer
@onready var play_button: Button = $PanelContainer/VBoxContainer/PanelContainer/PlayButton
@onready var quit_botton: Button = $PanelContainer/VBoxContainer/PanelContainer/QuitButton


@onready var size: Vector2 = DisplayServer.window_get_size()
var slot_button_scene: PackedScene = preload("res://screens/start/slot_button/slot_button.tscn")

var slot: Enums.AbilitySlot = Enums.AbilitySlot.Primary:
	set(change):
		slot = change
		select.emit(slot)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	base.size = size
	ability_container.custom_minimum_size = \
			Vector2(size.x * 9.2 / 10, size.y * 8 / 10)
	bottom_container.custom_minimum_size = Vector2(size.x, size.y * 1 / 10)
	bottom_button_container.custom_minimum_size = Vector2(size.x, size.y * 1 / 10)
	play_button.custom_minimum_size = size / 10
	quit_botton.custom_minimum_size = size / 12
	
	for button_slot: Enums.AbilitySlot in Enums.AbilitySlot.values():
		var slot_button: SlotButton = slot_button_scene.instantiate()
		slot_button_container.add_child(slot_button)
		slot_button._initilise(button_slot, Variables.ability_dict[button_slot], size / 10)
		select.connect(slot_button._on_select)
		ability_change.connect(slot_button._on_ability_change)
		slot_button.pressed.connect(_on_slot_button_pressed)
	select.emit(slot)
	
	for ability: Enums.Ability in Enums.Ability.values():
		var ability_button: AbilityButton = AbilityButton.new()
		ability_button._initilise(ability)
		ability_button.custom_minimum_size = size / 10
		ability_grid_container.add_child(ability_button)
		ability_button.ability_selected.connect(_on_ability_button_pressed)

func _on_ability_button_pressed(ability: Enums.Ability) -> void:
	Variables.ability_dict[slot] = ability
	ability_change.emit(slot, ability)
	if slot == Enums.AbilitySlot.size() - 1:
		slot = 0
	else:
		slot =  Enums.AbilitySlot[Enums.AbilitySlot.find_key(slot + 1)]

func _on_slot_button_pressed(pressed_slot: Enums.AbilitySlot):
	slot = pressed_slot

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://screens/sandbox/sandbox.tscn"))

func _on_quit_button_pressed() -> void:
	get_tree().quit()

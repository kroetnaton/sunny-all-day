extends Node2D

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

var slot: Enums.AbilitySlot = Enums.AbilitySlot.Primary

var ability_dict: Dictionary = {
	Enums.AbilitySlot.Primary: Enums.Ability.Nothing,
	Enums.AbilitySlot.Secondary: Enums.Ability.Nothing,
	Enums.AbilitySlot.Utility: Enums.Ability.Nothing,
	Enums.AbilitySlot.Special: Enums.Ability.Nothing,
}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	base.size = size
	ability_container.custom_minimum_size = \
			Vector2(size.x * 9.2 / 10, size.y * 8 / 10)
	bottom_container.custom_minimum_size = Vector2(size.x, size.y * 1 / 10)
	bottom_button_container.custom_minimum_size = Vector2(size.x, size.y * 1 / 10)
	play_button.custom_minimum_size = size / 10
	quit_botton.custom_minimum_size = size / 12
	
	for slot: Enums.AbilitySlot in Enums.AbilitySlot.values():
		var slot_button: SlotButton = slot_button_scene.instantiate()
		slot_button_container.add_child(slot_button)
		slot_button._initilise(slot, size / 10)
	
	for ability: Enums.Ability in Enums.Ability.values():
		var button: Button = Button.new()
		button.custom_minimum_size = size / 10
		button.text = Enums.Ability.find_key(ability)
		ability_grid_container.add_child(button)

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(load("res://screens/sandbox/sandbox.tscn"))

func _on_quit_button_pressed():
	get_tree().quit()

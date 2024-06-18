extends Node2D

@onready var base: PanelContainer = $PanelContainer
@onready var play_button: Button = $PanelContainer/PlayButton
@onready var quit_botton: Button = $PanelContainer/QuitButton
@onready var scroll_container: ScrollContainer = $PanelContainer/ScrollContainer
@onready var grid_container: GridContainer = $PanelContainer/ScrollContainer/GridContainer
@onready var slot_button_container: GridContainer = $PanelContainer/SlotButtonContainer
@onready var size: Vector2 = DisplayServer.window_get_size()

var ability_dict: Dictionary = {
	Enums.AbilitySlot.Primary: Enums.Ability.Nothing,
	Enums.AbilitySlot.Secondary: Enums.Ability.Nothing,
	Enums.AbilitySlot.Utility: Enums.Ability.Nothing,
	Enums.AbilitySlot.Special: Enums.Ability.Nothing,
}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	base.size = size
	scroll_container.custom_minimum_size = \
			Vector2(size.x * 9.2 / 10, size.y * 8 / 10)
	slot_button_container.custom_minimum_size = size * 2 / 10
	play_button.custom_minimum_size = size / 10
	quit_botton.custom_minimum_size = size / 12
	
	for slot: Enums.AbilitySlot in Enums.AbilitySlot.values():
		var button: Button = Button.new()
		button.custom_minimum_size = size / 10
		button.text = Enums.AbilitySlot.find_key(slot) + "\n---\n" + \
				Enums.Ability.find_key(ability_dict[slot])
		slot_button_container.add_child(button)
	
	for ability: Enums.Ability in Enums.Ability.values():
		var button: Button = Button.new()
		button.custom_minimum_size = size / 10
		button.text = Enums.Ability.find_key(ability)
		grid_container.add_child(button)

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(load("res://screens/sandbox/sandbox.tscn"))

func _on_quit_button_pressed():
	get_tree().quit()

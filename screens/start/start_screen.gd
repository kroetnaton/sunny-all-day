extends Node2D

@onready var base: PanelContainer = $PanelContainer
@onready var play_button: Button = $PanelContainer/PlayButton
@onready var quit_botton: Button = $PanelContainer/QuitButton
@onready var tab_container: TabContainer = $PanelContainer/TabContainer
@onready var size: Vector2 = DisplayServer.window_get_size()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	base.size = size
	tab_container.custom_minimum_size = size * 9 / 10
	play_button.custom_minimum_size = size / 10
	quit_botton.custom_minimum_size = size / 12

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(load("res://screens/sandbox/sandbox.tscn"))

func _on_quit_button_pressed():
	get_tree().quit()

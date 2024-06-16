extends Node2D

@onready var sandbox: PackedScene = preload("res://screens/sandbox/sandbox.tscn")

@onready var base: PanelContainer = $PanelContainer
@onready var play_button: Button = $PanelContainer/PlayButton
@onready var quit_botton: Button = $PanelContainer/QuitButton
@onready var tab_container: TabContainer = $PanelContainer/TabContainer
@onready var size: Vector2 = DisplayServer.window_get_size()

func _ready() -> void:
	base.size = size
	tab_container.custom_minimum_size = size * 9 / 10
	play_button.custom_minimum_size = size / 10
	quit_botton.custom_minimum_size = size / 12

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(sandbox)

func _on_quit_button_pressed():
	get_tree().quit()

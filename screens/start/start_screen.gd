extends Node2D

@onready var sandbox: PackedScene = preload("res://screens/sandbox/sandbox.tscn")

@onready var base: PanelContainer = $PanelContainer
@onready var play_button: Button = $PanelContainer/PlayButton
@onready var size: Vector2 = DisplayServer.window_get_size()

func _ready() -> void:
	base.size = size
	play_button.custom_minimum_size = size / 10

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(sandbox)

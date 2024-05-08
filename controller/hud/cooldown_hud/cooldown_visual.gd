extends ProgressBar
class_name CooldownVisual

var flash_duration: float = 0.1
var current_flash: float = flash_duration

@onready var style_box: StyleBoxFlat = get_theme_stylebox("Background")
@onready var default_color: Color = style_box.bg_color

func _process(delta: float) -> void:
	if current_flash < flash_duration:
		if current_flash == 0.0:
			visible = false
		if current_flash + delta >= flash_duration:
			visible = true
		current_flash += delta

func set_cooldown(time: float) -> void:
	max_value = time if time != 0.0 else 1.0
	value = time

func set_current(time: float) -> void:
	if time <= 0.0:
		current_flash = 0.0
	value = time

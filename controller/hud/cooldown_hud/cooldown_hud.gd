extends Node3D
class_name CooldownHud

@onready var cooldown_visual_dict: Dictionary = {
	Enums.AbilitySlot.Primary: $SubViewport/GridContainer/PanelContainerPrimary/CooldownPrimary,
	Enums.AbilitySlot.Secondary: $SubViewport/GridContainer/PanelContainerSecondary/CooldownSecondary,
	Enums.AbilitySlot.Utility: $SubViewport/GridContainer/PanelContainerUtility/CooldownUtility,
	Enums.AbilitySlot.Special: $SubViewport/GridContainer/PanelContainerSpecial/CooldownSpecial,
}

func _on_time_set(slot: Enums.AbilitySlot, time: float) -> void:
	cooldown_visual_dict[slot].set_cooldown(time)

func _on_time_change(slot: Enums.AbilitySlot, time: float) -> void:
	cooldown_visual_dict[slot].set_current(time)

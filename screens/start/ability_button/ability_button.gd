extends Button
class_name AbilityButton

signal ability_selected(ability: Enums.Ability)

var ability: Enums.Ability:
	set(change):
		ability = change
		text = Enums.Ability.find_key(ability)

func _initilise(i_ability: Enums.Ability) -> void:
	ability = i_ability
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	ability_selected.emit(ability)

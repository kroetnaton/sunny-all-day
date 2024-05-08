extends Node

var preload_dict: Dictionary = {
	Enums.Ability.Nothing: preload("res://abilities/nothing/nothing.tscn"),
	Enums.Ability.MachineGun: preload("res://abilities/machine_gun/machine_gun.tscn"),
	Enums.Ability.Shotgun: preload("res://abilities/shotgun/shotgun.tscn"),
	Enums.Ability.Hookshot: preload("res://abilities/hookshot/hookshot.tscn"),
	Enums.Ability.FreezeGranade: preload("res://abilities/freeze_granade/freeze_granade.tscn"),
	Enums.Ability.LaserShot: preload("res://abilities/laser_shot/laser_shot.tscn"),
	Enums.Ability.LaserCharges: preload("res://abilities/laser_charges/laser_charges.tscn"),
	Enums.Ability.LaserLightning: preload("res://abilities/laser_lightning/laser_lightning.tscn"),
	Enums.Ability.LaserGattling: preload("res://abilities/laser_gattling/laser_gattling.tscn"),
}

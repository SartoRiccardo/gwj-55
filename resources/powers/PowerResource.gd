extends Resource
class_name PowerResource

@export var name := ""
@export var charge_duration := 0.0
@export var effect_duration := 1.0
@export var spawn_chance := 0.2

@export_group("Power Info")
@export var full_name := ""
@export_multiline var power_description := ""

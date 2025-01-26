extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_apply_position()

func _apply_position():
	get_parent().position.y = randf_range(-8.0, 8.0)

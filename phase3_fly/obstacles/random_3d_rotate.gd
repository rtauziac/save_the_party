extends Node3D

@onready var axis_rotation = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _ready():
	rotate_y(randf_range(0, PI * 2))
	rotate_x(randf_range(0, PI * 2))


func _process(delta: float) -> void:
	rotation *= Quaternion(axis_rotation, delta * 2)

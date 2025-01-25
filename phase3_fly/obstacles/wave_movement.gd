extends Node3D

@export var wave_speed = 1.0
@onready var wave_offset = randf_range(0, 2 * PI)
var time = 0.0


func _ready() -> void:
	_apply_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_apply_position()
	time += delta


func _apply_position():
	get_parent().position.y = sin((time + wave_offset) * wave_speed) * 8

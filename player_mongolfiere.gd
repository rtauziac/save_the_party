extends Node3D

@export_range(0.05, 1) var acceleration_factor = 0.1
var jerk_vertical = 0.0
var acceleration_vertical = 0.0
var velocity_vertical = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	jerk_vertical = 1 if Input.is_action_pressed("blow") else -1
	acceleration_vertical = clamp(jerk_vertical, -1, 1)
	velocity_vertical += acceleration_vertical * acceleration_factor
	
	position.y += velocity_vertical * delta

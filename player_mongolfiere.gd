extends CharacterBody3D

signal player_dies

@export var scale_minimum = 1
@export var scale_maximum = 2.1
@export_range(0.05, 1) var acceleration_factor = 0.1
var jerk_vertical = 0.0
var acceleration_vertical = 0.0
var lives = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	jerk_vertical = 1.0 if Input.is_action_pressed("blow") else -1.0
	var prev_acceleration_vertical = acceleration_vertical
	acceleration_vertical = clamp(acceleration_vertical + jerk_vertical, -1.0, 1.0)
	velocity.y += acceleration_vertical * acceleration_factor
	
	
	var collides = move_and_slide()
	
	if collides:
		acceleration_vertical = 0.0
		velocity.y = (1 if position.y < 1 else -1) * 8
		player_takes_damage()
	
	var scale_scalar = remap(acceleration_vertical, -1.0, 1.0, scale_minimum, scale_maximum)
	var scale_vector = Vector3(scale_scalar, scale_scalar, scale_scalar)
	$Bubble.scale = lerp($"Bubble".scale, scale_vector, delta * 6.5)
	var sphere_shape = $CollisionShape3D.shape as SphereShape3D
	sphere_shape.radius = $Bubble.scale.x


func player_takes_damage():
	lives -= 1
	if lives == 0:
		player_dies.emit()

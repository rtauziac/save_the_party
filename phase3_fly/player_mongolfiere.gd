extends CharacterBody3D
class_name P3Player

signal player_dies
signal player_lives_changes(lives: int)

@export var scale_minimum = 1.4
@export var scale_maximum = 2.2
@export_range(0.05, 1) var acceleration_factor = 0.1
var jerk_vertical = 0.0
var acceleration_vertical = 0.0
var lives = 3
var hit_invicibility = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func alive() -> bool:
	return lives > 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if not alive():
		#return
	
	jerk_vertical = 1.0 if Input.is_action_pressed("blow") else -1.0
	var prev_acceleration_vertical = acceleration_vertical
	acceleration_vertical = clamp(acceleration_vertical + jerk_vertical, -0.6, 1.1)
	velocity.y += acceleration_vertical * acceleration_factor
	
	var scale_scalar = remap(acceleration_vertical, -1.0, 1.0, scale_minimum, scale_maximum)
	var scale_vector = Vector3(scale_scalar, scale_scalar, scale_scalar)
	$Bubble.scale = lerp($"Bubble".scale, scale_vector, delta * 6.5)
	var sphere_shape = $CollisionShape3D.shape as SphereShape3D
	sphere_shape.radius = $Bubble.scale.x
	
	var collides = move_and_slide()
	
	if collides:
		acceleration_vertical = 1 if position.y < 1 else -1
		velocity.y = (0.8 if position.y < 1 else -1) * 9
		if not hit_invicibility:
			take_damage()


func take_damage():
	lives -= 1
	player_lives_changes.emit(lives)
	if lives == 0:
		player_dies.emit()
	else:
		hit_invicibility = true
		$Bubble.blink_start()
		var invincibility_timer = get_tree().create_timer(3.0)
		invincibility_timer.timeout.connect(end_take_damage)


func end_take_damage():
	$Bubble.blink_end()
	hit_invicibility = false

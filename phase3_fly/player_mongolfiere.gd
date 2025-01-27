extends CharacterBody3D
class_name P3Player

signal player_dies
signal player_lives_changes(lives: int)

@export var scale_minimum = 1.4
@export var scale_maximum = 2.2
@export_range(0.05, 1) var acceleration_factor = 0.1
var jerk_vertical = 0.0
var acceleration_vertical = 0.0
@export var lives = 3
var hit_invicibility = false 
var halted = true
var end_phase = false
var game_ended = false
@export var end_speed = 4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func alive() -> bool:
	return lives > 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not alive() or game_ended:
		return
	
	jerk_vertical = 1.0 if Input.is_action_pressed("blow") else -1.0
	var prev_acceleration_vertical = acceleration_vertical
	acceleration_vertical = clamp(acceleration_vertical + jerk_vertical, -0.6, 1.1)
	velocity.y += acceleration_vertical * acceleration_factor
	
	var scale_scalar = remap(acceleration_vertical, -1.0, 1.0, scale_minimum, scale_maximum)
	var scale_vector = Vector3(scale_scalar, scale_scalar, scale_scalar)
	$Bubble/BubbleSprite.scale = lerp($"Bubble/BubbleSprite".scale, scale_vector * 4.742, delta * 6.5)
	var sphere_shape = $CollisionShape3D.shape as SphereShape3D
	sphere_shape.radius = $Bubble/BubbleSprite.scale.x / 4.742
	
	var shadow1: Sprite3D = get_parent_node_3d().get_node("StaticBody3D/CollisionShape3D/BlobShadow")
	var shadow2: Sprite3D = get_parent_node_3d().get_node("StaticBody3D/CollisionShape3D2/BlobShadow")
	var scale1 = max(10 - global_position.distance_to(shadow1.global_position), 0)
	var scale2 = max(10 - global_position.distance_to(shadow2.global_position), 0)
	shadow1.scale = Vector3(scale1, scale1, scale1)
	shadow2.scale = Vector3(scale2, scale2, scale2)
	
	if halted:
		velocity.y = 0
	else:
		if end_phase:
			velocity.x = end_speed
		
		var collides = move_and_slide()
		
		var static_floor_ceiling: Node3D = get_parent().get_node("StaticBody3D")
		static_floor_ceiling.position.x = position.x
	
		if collides:
			acceleration_vertical = 1 if position.y < 1 else -1
			velocity.y = (0.8 if position.y < 1 else -1) * 9
			if not hit_invicibility:
				take_damage()


func take_damage():
	if end_phase:
		lives = 0
	else:
		lives -= 1
	player_lives_changes.emit(lives)
	if lives == 0:
		player_dies.emit()
		get_parent().kill_camera()
	else:
		hit_invicibility = true
		$Bubble.blink_start()
		var invincibility_timer = get_tree().create_timer(3.0)
		invincibility_timer.timeout.connect(end_take_damage)


func end_take_damage():
	$Bubble.blink_end()
	hit_invicibility = false


func _on_start_timer_timeout() -> void:
	start_game()


func start_game() -> void:
	halted = false


func end_wall_touched() -> void:
	lives = 0


func end_button_touched() -> void:
	game_ended = true


func kill_anim():
	$PlayerAnimationPlayer.play("kill_explode")


func _on_area_3d_end_body_entered(body: Node3D) -> void:
	if body == self:
		end_phase = true

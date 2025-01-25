extends Node3D

var speed = 5.0
var last_spawn_distance = 0.0
@export var spawn_distance = 20.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$obstacle_instances.position.x -= speed * delta
	var actual_x_pos = -$obstacle_instances.position.x
	if actual_x_pos > last_spawn_distance + spawn_distance:
		#spawn obstacle
		var obstacle_index = randi_range(0, 3 - 1)
		last_spawn_distance = actual_x_pos

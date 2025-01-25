extends Node3D

var speed = 5.0
var last_spawn_distance = 0.0
@export var spawn_distance = 20.0

var obstacles = [
	preload("res://phase3_fly/obstacles/teacup.tscn")
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$obstacle_instances.position.x -= speed * delta
	var actual_x_pos = -$obstacle_instances.position.x
	if actual_x_pos > last_spawn_distance + spawn_distance:
		var obstacle_index = randi_range(0, obstacles.size() - 1)
		var obstacle_scene: PackedScene = obstacles[obstacle_index]
		var obstacle_instance: Node3D = obstacle_scene.instantiate()
		$obstacle_instances.add_child(obstacle_instance)
		obstacle_instance.global_position = Vector3($spawn.global_position.x, obstacle_instance.global_position.y, obstacle_instance.global_position.z)
		last_spawn_distance = actual_x_pos

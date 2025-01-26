extends Node3D

var speed = 8
@export var stopped = true
var last_spawn_distance = 0.0 # the last spawn place
@export var min_spawn_distance = 10.0
@export var max_spawn_distance = 20.0
@export var max_object_spawned = 20
var next_spawn_distance = self.min_spawn_distance # distance from last spawn to next spawn
var object_spawn_count = 0
var end_reached = false


var obstacles = [
	preload("res://phase3_fly/obstacles/mouse.tscn"),
	preload("res://phase3_fly/obstacles/teacup2.tscn"),
	preload("res://phase3_fly/obstacles/spider.tscn"),
	preload("res://phase3_fly/obstacles/carot.tscn"),
	preload("res://phase3_fly/obstacles/tuyau.tscn")
]


func _ready():
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$obstacle_instances.position.x -= speed * delta
	$KitchenBG.position.x = $obstacle_instances.position.x
	var actual_x_pos = -$obstacle_instances.position.x
	if actual_x_pos > last_spawn_distance + next_spawn_distance and not end_reached:
		if object_spawn_count < max_object_spawned:
			_spawn_random_obstacle(actual_x_pos)
			next_spawn_distance = randf_range(min_spawn_distance, max_spawn_distance)
			object_spawn_count += 1
		else:
			end_reached = true
			var end_wall: Node3D = $EndWall
			end_wall.reparent($obstacle_instances, true)
			#var wall_pos = end_wall.global_position
			#end_wall.get_parent().remove_child(end_wall)
			#$obstacle_instances.add_child(end_wall)
			#end_wall.global_position = wall_pos
	
	# move kitchen BG
	for kitchen in $KitchenBG.get_children():
		var kitchen3D = kitchen as Node3D
		if kitchen3D.global_position.x < -60:
			kitchen3D.global_position.x += 31.0 * 4.0


func _spawn_random_obstacle(actual_x_pos: float) -> void:
	var obstacle_index = randi_range(0, obstacles.size() - 1)
	var obstacle_scene: PackedScene = obstacles[obstacle_index]
	var obstacle_instance: Node3D = obstacle_scene.instantiate()
	$obstacle_instances.add_child(obstacle_instance)
	obstacle_instance.global_position = Vector3($spawn.global_position.x, obstacle_instance.global_position.y, obstacle_instance.global_position.z)
	last_spawn_distance = actual_x_pos


func _on_game_start() -> void:
	stopped = false
	set_process(true)


func _on_player_player_dies() -> void:
	stopped = true
	set_process(false)


func _on_area_3d_end_body_entered(body: Node3D) -> void:
	stopped = true
	set_process(false)

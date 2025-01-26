extends Node3D

var destroy_on_obstacle_destroyer_hit = true
@export var delete_parent = false

func _on_body_entered(body: Node3D) -> void:
	var player = body as P3Player
	if player != null:
		if not player.hit_invicibility and player.alive():
			player.take_damage()


func _on_area_3d_area_entered(area: Area3D) -> void:
	var obstacle_destroyer = area
	if obstacle_destroyer.name == "DestroyObstacle":
		if delete_parent:
			get_parent().get_parent().queue_free()
		else:
			get_parent().queue_free()

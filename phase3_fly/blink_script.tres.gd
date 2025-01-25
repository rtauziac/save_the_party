extends MeshInstance3D


var time = -1.0
var blink_time = 0.06


func _process(delta: float) -> void:
	if time >= 0.0:
		time += delta
		visible = fposmod(time, blink_time) > blink_time / 2.0


func blink_start():
	time = 0.0


func blink_end():
	visible = true
	time = -1.0

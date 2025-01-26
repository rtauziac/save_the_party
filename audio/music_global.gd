extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$" MainMusic".play()
	$" EndMusic".play()


func crossfade_end():
	pass
	#var crossfade_tween = get_tree().create_tween()
	#crossfade_tween.tween_property()
#

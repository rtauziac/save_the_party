extends Node

var music_enabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicGlobal.manager = self
	if not music_enabled:
		return
	
	start_game_music()


func start_game_music():
	$" MainMusic".play()
	$" EndMusic".play()


func crossfade_end():
	pass
	#var crossfade_tween = get_tree().create_tween()
	#crossfade_tween.tween_property()
#

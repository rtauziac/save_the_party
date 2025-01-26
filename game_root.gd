extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StartTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var keyEvent = event as InputEventKey
		if keyEvent.keycode == KEY_R:
			restart_game()


func restart_game():
	MusicGlobal.manager.crossfade_restart()
	get_tree().reload_current_scene()

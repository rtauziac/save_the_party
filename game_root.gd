extends Node3D

var a_property = "hello"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StartTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#var input_mouse_button_event: InputEventMouseButton = event
		#if input_mouse_button_event.button_index == MOUSE_BUTTON_LEFT and input_mouse_button_event.pressed:
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventKey:
		var keyEvent = event as InputEventKey
		if keyEvent.keycode == KEY_R:
			restart_game()


func kill_camera():
	var camera_tween = get_tree().create_tween().set_parallel(true)
	camera_tween.tween_property($Camera3D, "global_position", $Player/Marker3DKillPosition.global_position, 1)
	camera_tween.tween_property($Camera3D, "fov", 45, 1)
	camera_tween.chain().set_parallel(false)
	camera_tween.tween_callback(func():$Player.kill_anim())
	camera_tween.tween_interval(3.7)
	camera_tween.tween_callback($CanvasLayerUI/ColorRect.fade_out)
	camera_tween.tween_interval(1.7)
	camera_tween.tween_callback(func():MusicGlobal.manager.crossfade_restart())
	camera_tween.tween_callback(func():get_tree().reload_current_scene())
	


func restart_game():
	MusicGlobal.manager.crossfade_restart()
	get_tree().reload_current_scene()

extends Node
class_name GameMusicManager

var music_enabled = false

var main_audio_bus_level: set = main_audio_bus_level_set, get = main_audio_bus_level_get
func main_audio_bus_level_set(val):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Main"), val)
func main_audio_bus_level_get():
	AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Main"))
	
var end_audio_bus_level: set = end_audio_bus_level_set, get = end_audio_bus_level_get
func end_audio_bus_level_set(val):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("End"), val)
func end_audio_bus_level_get():
	AudioServer.get_bus_volume_db(AudioServer.get_bus_index("End"))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicGlobal.manager = self
	if not music_enabled:
		return
	
	start_game_music()


func start_game_music():
	$MainMusic.play()
	$EndMusic.play()
	main_audio_bus_level_set(-10)
	end_audio_bus_level_set(-80)


func crossfade_end():
	var crossfade_tween = get_tree().create_tween().set_parallel(true)
	crossfade_tween.tween_method(self.end_audio_bus_level_set, -80, -10, 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	crossfade_tween.tween_method(self.main_audio_bus_level_set, -10, -80, 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)


func crossfade_restart():
	var crossfade_tween = get_tree().create_tween().set_parallel(true)
	crossfade_tween.tween_method(self.main_audio_bus_level_set, -80, -10, 2)
	crossfade_tween.tween_method(self.end_audio_bus_level_set, -10, -80, 2)


func start_win_music():
	$MainMusic.stop()
	$EndMusic.stop()
	$WinMusic.play()

extends Node

@onready var record: AudioEffectRecord
var recording: AudioStreamWAV
var spectrum_analyzer: AudioEffectSpectrumAnalyzer
var max_volume = 0.0001
var prev_volume = 0.0


func _ready() -> void:
	if OS.get_name() == "Web":
		queue_free()
		return
	var delay_start = get_tree().create_timer(0.5)
	delay_start.timeout.connect(func():
		$AudioStreamPlayer.play(0.0)
		record = AudioServer.get_bus_effect(AudioServer.get_bus_index("Record"), 0)
		record.set_recording_active(true)
		spectrum_analyzer = AudioServer.get_bus_effect(AudioServer.get_bus_index("Record"), 1)
		)


func _enter_tree() -> void:
	if record != null:
		record.set_recording_active(true)
		recording = record.get_recording()
		


func _exit_tree() -> void:
	if record != null:
		record.set_recording_active(false)
	$AudioStreamPlayer.stop()


func _on_blow_poll_timer_timeout() -> void:
	if record == null:
		return
	
	recording = record.get_recording()
	var analyzer: AudioEffectSpectrumAnalyzerInstance = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index("Record"), 1)
	
	if recording == null:
		return
	
	var volume = analyzer.get_magnitude_for_frequency_range(90, 155, AudioEffectSpectrumAnalyzerInstance.MAGNITUDE_MAX)
	max_volume = max(volume[0], max_volume)
	var player: P3Player = get_parent()
	prev_volume = lerp(prev_volume, volume[0], 0.8)
	if not player.halted:
		player.blow_volume = clamp(prev_volume / (max_volume * 0.5), 0, 1)
	

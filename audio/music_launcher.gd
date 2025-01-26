extends Node

var manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mg = load("res://audio/MusicGlobal.tscn") as PackedScene
	var mg_instance = mg.instantiate()
	add_child(mg_instance)

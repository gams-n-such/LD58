#class_name TitleScreen
extends Node


func _ready() -> void:
	Game.set_main_ambience_playing(true, 5.0)
	await get_tree().create_timer(10).timeout
	Game.set_main_ambience_playing(false, 5.0)

func _process(delta: float) -> void:
	pass

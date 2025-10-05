#class_name TitleScreen
extends Node

@onready var MAIN_MENU := %MainMenu
@onready var CREDITS := %Credits
@onready var RETURN_BUTTON := %ReturnButton

func _ready() -> void:
	Game.set_main_ambience_playing(true, 5.0)

func start_game() -> void:
	pass

func show_credits() -> void:
	await curtain_fade_in(3)
	MAIN_MENU.visible = false
	CREDITS.visible = true
	RETURN_BUTTON.visible = true
	await curtain_fade_out(3)

func return_to_main_menu() -> void:
	await curtain_fade_in(3)
	MAIN_MENU.visible = true
	CREDITS.visible = false
	RETURN_BUTTON.visible = false
	await curtain_fade_out(3)

#region Curtain

@onready var CURTAIN := %Curtain
@onready var CURTAIN_FADER := %CurtainFader

func curtain_fade_in(fade_time : float) -> void:
	var fade_speed : float = 1.0 / fade_time if fade_time > 0.0 else 100.0
	CURTAIN_FADER.play("curtain_fade_in", -1, fade_speed)
	CURTAIN.visible = true
	await CURTAIN_FADER.animation_finished

func curtain_fade_out(fade_time : float) -> void:
	var fade_speed : float = 1.0 / fade_time if fade_time > 0.0 else 100.0
	CURTAIN_FADER.play("curtain_fade_in", -1, -fade_speed, true)
	await CURTAIN_FADER.animation_finished
	CURTAIN.visible = false

#endregion


func _on_play_button_pressed() -> void:
	start_game()

func _on_credits_button_pressed() -> void:
	show_credits()

func _on_return_button_pressed() -> void:
	return_to_main_menu()

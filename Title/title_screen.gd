#class_name TitleScreen
extends Node

@onready var MAIN_MENU := %MainMenu
@onready var CREDITS := %Credits
@onready var RETURN_BUTTON := %ReturnButton

@onready var CURTAIN := %Curtain
var default_curtain_fade := 3.0

func _ready() -> void:
	Game.set_main_ambience_playing(true, 5.0)
	await CURTAIN.fade_out(5)

func start_game() -> void:
	await CURTAIN.fade_in(default_curtain_fade)
	Game.start_intro()

func show_credits() -> void:
	await CURTAIN.fade_in(default_curtain_fade)
	MAIN_MENU.visible = false
	CREDITS.visible = true
	RETURN_BUTTON.visible = true
	await CURTAIN.fade_out(default_curtain_fade)

func return_to_main_menu() -> void:
	await CURTAIN.fade_in(default_curtain_fade)
	MAIN_MENU.visible = true
	CREDITS.visible = false
	RETURN_BUTTON.visible = false
	await CURTAIN.fade_out(default_curtain_fade)

func _on_play_button_pressed() -> void:
	start_game()

func _on_credits_button_pressed() -> void:
	show_credits()

func _on_return_button_pressed() -> void:
	return_to_main_menu()

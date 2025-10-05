extends Node

@onready var CURTAIN : Curtain = %Curtain
@onready var MAIN_LEVEL: Node = %MainLevel


func _ready() -> void:
	#await CURTAIN.fade_out(3)
	%IntroAnim.play("intro")
	await %IntroAnim.animation_finished
	await CURTAIN.fade_in(3)
	%Intro.visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	MAIN_LEVEL.reparent(get_tree().root)
	get_tree().current_scene = MAIN_LEVEL
	MAIN_LEVEL.process_mode = Node.PROCESS_MODE_INHERIT
	await CURTAIN.fade_out(3)
	queue_free()

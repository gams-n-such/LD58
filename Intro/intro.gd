extends Node

@onready var CURTAIN : Curtain = %Curtain


func _ready() -> void:
	#await CURTAIN.fade_out(3)
	%IntroAnim.play("intro")
	await %IntroAnim.animation_finished
	await CURTAIN.fade_in(3)
	%Intro.visible = false
	%MainLevel.process_mode = Node.PROCESS_MODE_INHERIT
	await CURTAIN.fade_out(3)
	%MainLevel.reparent(get_tree().root)
	get_tree().current_scene = %MainLevel
	queue_free()

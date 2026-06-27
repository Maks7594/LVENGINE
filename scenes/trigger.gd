class_name Trigger extends Node2D

@onready var ui = $"../UI"

func disable():
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	$CollisionShape2D.set_deferred("disabled", true)

func trigger():
	ui.do_textbox("* Trigger jumpscare\n* BOO")

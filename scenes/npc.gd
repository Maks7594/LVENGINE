class_name NPC extends Node2D

@onready var ui = $"../UI"

func interact():
	ui.do_textbox("* I have moved\n* Thy Window")
	Funcs.meta("tweenpos", Vector2i(100, 100), 0.5)

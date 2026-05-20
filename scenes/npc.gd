class_name NPC extends Node2D

@onready var ui = $"../UI"

func interact():
	ui.do_textbox("* Hello, world!")

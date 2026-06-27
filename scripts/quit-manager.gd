extends Node

var canvas = CanvasLayer.new()
var quit_label = Label.new()

var tween_can_play := true
var holding := true
var hold_time := 0.0
const max_hold_time := 0.6

func _ready():
	add_child(canvas)
	quit_label.modulate.a = 0
	canvas.add_child(quit_label)
	
	quit_label.position = Vector2(3, 0)
	quit_label.text = "Quitting"
	quit_label.theme = load("res://themes/quitting.tres")

func update_ui():
	if not holding:
		quit_label.text = "Quitting"
		var tween = create_tween()
		tween.tween_property(quit_label, "modulate:a", 0.0, 0.2)
	else:
		if tween_can_play:
			var tween2 = create_tween()
			tween2.tween_property(quit_label, "modulate:a", 1.0, 0.4)
	if hold_time > 0.3:
		quit_label.text = "Quitting."

func _process(delta):
	if Input.is_action_pressed("quit"):
		holding = true
		hold_time += delta
		update_ui()
		
		if hold_time >= max_hold_time:
			get_tree().quit(0)
	else:
		holding = false
		hold_time = 0
		update_ui()

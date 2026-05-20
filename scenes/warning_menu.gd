extends Control

func _input(event):
	if event.is_action_pressed("confirm"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _ready():
	print("LVENGINE by Maximized")
	
	PlayerVars.load_settings()
	PlayerVars.apply_settings()
	
	if PlayerVars.detect_ut() == "":
		$ErrorLabel.visible = true
	
	var tween1 = create_tween()
	tween1.tween_property($Label, "modulate:a", 1.0, 0.5)
	
	await tween1.finished
	await get_tree().create_timer(2.0).timeout # wait for 3s
	
	var tween2 = create_tween()
	tween2.tween_property($Label, "modulate:a", 0.0, 0.5)
	
	await tween2.finished
	await get_tree().create_timer(0.25).timeout
	
	$TextureRect.visible = true
	$Splash.play()
	await get_tree().create_timer(4).timeout
	
	$Label2.visible = true

extends CharacterBody2D

@onready var sprite = $Sprite
@onready var snd_confirm = $"../CanvasLayer/SFX/Confirm"
@onready var snd_select = $"../CanvasLayer/SFX/Select"
@onready var snd_item = $"../CanvasLayer/SFX/Item"

@onready var ui = $"/root/CanvasLayer"

var speed := 150.0
var run_speed := 200.0

# This will store "x" or "y" to remember what we pressed first
var face_priority = ""

func ui_visibility(dont_hide:bool):
	if dont_hide:
		$"../CanvasLayer".visible = true
		$"../CanvasLayer/QuickInfo".visible = true
		$"../CanvasLayer/SubmenuSelector".visible = true
		$"../CanvasLayer/Soul".visible = true
	else:
		$"../CanvasLayer".visible = false
		$"../CanvasLayer/QuickInfo".visible = false
		$"../CanvasLayer/SubmenuSelector".visible = false
		$"../CanvasLayer/Soul".visible = false
	
	$"../CanvasLayer".update_ui()

func _physics_process(_delta: float):
	if PlayerData.global["interact"]:
		var x := Input.get_axis("left", "right")
		var y := Input.get_axis("up", "down")
		
		if face_priority == "":
			if x != 0: face_priority = "x"
			elif y != 0: face_priority = "y"
		
		if x != 0 and y == 0:
			face_priority = "x"
		elif y != 0 and x == 0:
			face_priority = "y"
		
		if x == 0 and y == 0:
			face_priority = ""
	
		velocity.x = x * speed
		velocity.y = y * speed
	
		move_and_slide()
		update_animation(x, y)
		
		if Input.is_action_just_pressed("menu"):
			ui_visibility(true)
			Funcs.do_sound(snd_select)
			PlayerData.global["interact"] = false
			PlayerData.global["menu_open"] = true
		if Input.is_action_just_pressed("ui_home"):
			$"../CanvasLayer".visible = true
			$"../CanvasLayer/Textbox".visible = true
			$"../CanvasLayer/Textbox/TypeWriterLabel".typewrite($"../CanvasLayer/Textbox/TypeWriterLabel".text)
		if Input.is_key_pressed(KEY_F1):
			PlayerData.player["hp"] = 5
		elif Input.is_key_pressed(KEY_F2):
			PlayerData.player["hp"] = 10
		elif Input.is_key_pressed(KEY_F3):
			PlayerData.player["hp"] = 20
	else:
		return

func update_animation(x, y):
	if x == 0 and y == 0:
		sprite.stop()
		return

	if face_priority == "x":
		if x > 0: sprite.play("right")
		elif x < 0: sprite.play("left")
	
	elif face_priority == "y":
		if y > 0: sprite.play("down")
		elif y < 0: sprite.play("up")

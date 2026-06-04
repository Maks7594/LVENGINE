extends CharacterBody2D

@onready var sprite = $Sprite
@onready var snd_confirm = $"../UI/SFX/Confirm"
@onready var snd_select = $"../UI/SFX/Select"
@onready var snd_item = $"../UI/SFX/Item"

@onready var cast = $InteractionRaycast

@onready var ui = $"/root/UI"

var v = Vector2.ZERO
var speed := 150.0
var run_speed := 200.0
var looking = Vector2.DOWN
var interaction_distance := 20

# This will store "x" or "y" to remember what we pressed first
var face_priority = ""

func update_cast():
	cast.target_position = looking * interaction_distance

func _input(event):
	if PlayerVars.settings["debug"]:
		if Input.is_key_pressed(KEY_F1):
			PlayerData.player["hp"] = 5
		elif Input.is_key_pressed(KEY_F2):
			PlayerData.player["hp"] = 10
		elif Input.is_key_pressed(KEY_F3):
			PlayerData.player["hp"] = 20
	
	if event.is_action_pressed("confirm"):
		if cast.is_colliding() and PlayerData.global["interact"]:
			var target = cast.get_collider()
			if target.has_method("interact"):
				target.interact()

func _physics_process(_delta: float):
	if PlayerData.global["cam_active"]:
		if not $"../Camera" == null:
			#$"../Camera".position.x = lerp($"../Camera".position.x, position.x, 0.1)
			#$"../Camera".position.y = lerp($"../Camera".position.y, position.y, 0.1)
			$"../Camera".position.x = position.x
			$"../Camera".position.y = position.y
	
	v = Vector2.ZERO
	v.x = Input.get_axis("left", "right")
	v.y = Input.get_axis("up", "down")
	
	if PlayerData.global["interact"]:
		if v != Vector2.ZERO:
			looking = v
			update_cast()
		
		if face_priority == "":
			if v.x != 0: face_priority = "x"
			elif v.y != 0: face_priority = "y"
		
		if v.x != 0 and v.y == 0:
			face_priority = "x"
		elif v.x == 0 and v.y != 0:
			face_priority = "y"
		
		if v.x == 0 and v.y == 0:
			face_priority = ""
	
		velocity.x = v.x * speed
		velocity.y = v.y * speed
	
		move_and_slide()
		
	update_animation(v.x, v.y)

func update_animation(x, y):
	if x == 0 and y == 0 or not PlayerData.global["interact"]:
		sprite.stop()
		return

	if face_priority == "x":
		if x > 0: sprite.play("right")
		elif x < 0: sprite.play("left")
	
	elif face_priority == "y":
		if y > 0: sprite.play("down")
		elif y < 0: sprite.play("up")

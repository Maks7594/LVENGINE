extends CharacterBody2D

@onready var sprite = $Sprite
@onready var snd_confirm = $"../UI/SFX/Confirm"
@onready var snd_select = $"../UI/SFX/Select"
@onready var snd_item = $"../UI/SFX/Item"

@onready var raycast = $InteractionRaycast

@onready var ui = $"/root/UI"

var speed := 150.0
var run_speed := 200.0
var looking = Vector2.DOWN
var interaction_distance := 20

# This will store "x" or "y" to remember what we pressed first
var face_priority = ""

func update_raycast():
	raycast.target_position = looking * interaction_distance

func _input(event):
	if Input.is_key_pressed(KEY_F1):
		PlayerData.player["hp"] = 5
	elif Input.is_key_pressed(KEY_F2):
		PlayerData.player["hp"] = 10
	elif Input.is_key_pressed(KEY_F3):
		PlayerData.player["hp"] = 20
	
	if event.is_action_pressed("confirm"):
		if raycast.is_colliding():
			var target = raycast.get_collider()
			if target.has_method("interact"):
				print("running method")
				target.interact()

func _physics_process(_delta: float):
	if PlayerData.global["cam_active"]:
		if not $"../Camera" == null:
			$"../Camera".position.x = lerp($"../Camera".position.x, position.x, 0.1)
			$"../Camera".position.y = lerp($"../Camera".position.y, position.y, 0.1)
	if PlayerData.global["interact"]:
		var v = Vector2.ZERO
		v.x = Input.get_axis("left", "right")
		v.y = Input.get_axis("up", "down")
		
		if v != Vector2.ZERO:
			looking = v
			update_raycast()
		
		if face_priority == "":
			if v.x != 0: face_priority = "x"
			elif v.y != 0: face_priority = "y"
		
		if v.x != 0 and v.y == 0:
			face_priority = "x"
		elif v.y != 0 and v.x == 0:
			face_priority = "y"
		
		if v.x == 0 and v.y == 0:
			face_priority = ""
	
		velocity.x = v.x * speed
		velocity.y = v.y * speed
	
		move_and_slide()
		update_animation(v.x, v.y)
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

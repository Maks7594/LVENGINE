extends CharacterBody2D

@onready var sprite = $Sprite
@onready var snd_confirm = $"../UI/SFX/Confirm"
@onready var snd_select = $"../UI/SFX/Select"
@onready var snd_item = $"../UI/SFX/Item"

const base_speed := 150.0
const base_slow_speed := 75.0

var is_active := false
var speed := 150.0
var slow_speed := 75.0
var mode := 0

func red_soul():
	var x := Input.get_axis("left", "right")
	var y := Input.get_axis("up", "down")
	
	if Input.is_action_pressed("cancel"):
		velocity.x = x * slow_speed
		velocity.y = y * slow_speed
	else:
		velocity.x = x * speed
		velocity.y = y * speed
		
	move_and_slide()

func _physics_process(_delta: float):
	if is_active:
		match mode:
			0:
				red_soul()
			1:
				pass # light blue soul mode
			2:
				pass # orange soul mode
			3:
				pass # blue soul mode
			4:
				pass # purple soul mode
			5:
				pass # green soul mode
			6:
				pass # yellow soul mode
			_:
				red_soul()

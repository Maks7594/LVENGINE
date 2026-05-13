extends CharacterBody2D

@onready var sprite = $Sprite
@onready var snd_confirm = $"../UI/SFX/Confirm"
@onready var snd_select = $"../UI/SFX/Select"
@onready var snd_item = $"../UI/SFX/Item"

@onready var ui = $"/root/UI"

var is_active := false
var speed := 150.0
var mode := 0

# This will store "x" or "y" to remember what we pressed first
var face_priority = ""

func _physics_process(_delta: float):
	if is_active:
		var x := Input.get_axis("left", "right")
		var y := Input.get_axis("up", "down")
	
		velocity.x = x * speed
		velocity.y = y * speed
	
		move_and_slide()

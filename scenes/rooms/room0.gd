extends Node2D

@onready var snd_click = $SFX/Click
@onready var snd_enterbattle = $SFX/StartBattle
@onready var overlay = $World/UI/Overlay
@onready var soul = $World/UI/CosmeticSoul

func show_textbox(text):
	var label = $World/UI/Textbox/TypeWriterLabel
	
	PlayerData.global["interact"] = false
	$World/UI/Textbox.visible = true
	label.typewrite(text)
	
	if not label.is_typing():
		if Input.is_action_just_pressed("confirm"):
			label.text = ""
			$World/UI/Textbox.visible = false
			PlayerData.global["interact"] = true
	else:
		if Input.is_action_just_pressed("cancel"):
			label.skip_typing()

func start_battle_anim():
	PlayerData.global["interact"] = false
	var sprite_screen_pos = $World/Player/Sprite.get_global_transform_with_canvas().origin
	soul.global_position = sprite_screen_pos - (soul.size / 2.0)
	
	var s := 0.07
	
	overlay.visible = true
	Funcs.do_sound(snd_click)
	soul.visible = true
	await get_tree().create_timer(s).timeout
	soul.visible = false
	await get_tree().create_timer(s).timeout
	Funcs.do_sound(snd_click)
	soul.visible = true
	await get_tree().create_timer(s).timeout
	soul.visible = false
	await get_tree().create_timer(s).timeout
	Funcs.do_sound(snd_click)
	soul.visible = true
	await get_tree().create_timer(s+0.03).timeout
	Funcs.do_sound(snd_enterbattle)
	var tween = create_tween()
	tween.tween_property(soul, "position", Vector2(41, 446), 0.5).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	await get_tree().create_timer(0.1).timeout
	$Battle.start_battle()

func _ready():
	if PlayerVars.settings["music"]:
		$SFX/Music.play()
	
	var tween = create_tween()
	tween.tween_property($UI/Overlay, "modulate:a", 0.0, 0.3)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_home"):
		start_battle_anim()

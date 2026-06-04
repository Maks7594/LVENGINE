extends Node2D

@onready var snd_click = $SFX/Click
@onready var snd_enterbattle = $SFX/StartBattle
@onready var overlay = $World/UI/Overlay
@onready var soul = $World/UI/CosmeticSoul

func _ready():
	PlayerVars.load_settings()
	PlayerVars.apply_settings()
	PlayerVars.detect_ut()
	
	if PlayerVars.other["undertale_detected"] != "":
		print("Trying path " + PlayerVars.other["undertale_detected"] + "mus_ruins.ogg")
		var mus_bytes: PackedByteArray = FileAccess.get_file_as_bytes(PlayerVars.other["undertale_detected"] + "mus_ruins.ogg")
		if mus_bytes.is_empty():
			print("Music file is empty!")
			$Settings/MusErrorLabel.visible = true
			return
		var mus_stream := AudioStreamOggVorbis.load_from_buffer(mus_bytes)
		mus_stream.loop = true
		$SFX/Music.stream = mus_stream
	Funcs.do_music($SFX/Music)
	
	var tween = create_tween()
	tween.tween_property($UI/Overlay, "modulate:a", 0.0, 0.3)

func start_battle_anim():
	$SFX/Music.playing = false
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
	$Battle.start_battle(load("res://data/encounters/test.tres"))

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_home"):
		start_battle_anim()

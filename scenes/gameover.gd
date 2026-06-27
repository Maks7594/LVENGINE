extends Control

var textbox_done := false
var multidialogue := [
	"You cannot give up just yet...",
	"%s!" % PlayerData.player["name"],
	"Stay determined..."
]
var cur_page := 0

func _on_typewriting_done() -> void:
	textbox_done = true

func _ready():
	PlayerVars.load_settings()
	PlayerVars.apply_settings()
	PlayerVars.detect_ut()
	
	if PlayerVars.other["undertale_detected"] != "":
		var mus_bytes: PackedByteArray = FileAccess.get_file_as_bytes(PlayerVars.other["undertale_detected"] + "mus_gameover.ogg")
		if mus_bytes.is_empty():
			print("Music file is empty!")
			return
		var mus_stream := AudioStreamOggVorbis.load_from_buffer(mus_bytes)
		mus_stream.loop = true
		$Music.stream = mus_stream
		Funcs.do_music($Music)
	
	var tween = create_tween()
	tween.tween_property($TextureRect, "modulate:a", 1, 1)
	
	await get_tree().create_timer(2).timeout
	
	do_multipage_textbox(multidialogue, false)

func _physics_process(_delta):
	if $TypeWriterLabel.visible:
		if $TypeWriterLabel.is_typing():
			if Input.is_action_pressed("cancel"):
				$TypeWriterLabel.skip_typing()
		if textbox_done and Input.is_action_just_pressed("confirm"):
			textbox_done = false
			cur_page += 1
			do_multipage_textbox(multidialogue, true)

func do_multipage_textbox(dialogue: Array, js_type: bool):
	if not js_type:
		multidialogue = dialogue
		$TypeWriterLabel.typewrite(dialogue[0])
	else:
		if cur_page >= dialogue.size():
			textbox_done = false
			multidialogue = []
			cur_page = 0
			textbox_done = false
			$TypeWriterLabel.visible = false
			end()
		else:
			$TypeWriterLabel.typewrite(dialogue[cur_page])

func end():
	await get_tree().create_timer(2).timeout
	
	var tween = create_tween()
	tween.tween_property($TextureRect, "modulate:a", 0, 1)
	
	var tween2 = create_tween()
	tween2.tween_property($Music, "volume_db", linear_to_db(0), 1)
	
	await get_tree().create_timer(1.5).timeout
	
	get_tree().change_scene_to_file("res://scenes/rooms/room0.tscn")

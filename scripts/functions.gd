extends Node

# randi_range(-p1, p1), randi_range(-p1, p1)

var shaking := "none"
var shaking_timer := 0
var window_pos: Vector2i

var og_p1 := 0
var og_p2 := 0
var p1 := 0
var p2 := 0

func _process(_delta):
	if shaking == "yes":
		get_window().position = Vector2i(
		window_pos.x + randi_range(-p1, p1),
		window_pos.y + randi_range(-p1, p1))
		
		p2 -= 1
		
		if p2 == 0:
			shaking = "none"
			p1 = 0
			p2 = 0
			get_window().position = window_pos
	
	elif shaking == "smooth":
		get_window().position = Vector2i(
		window_pos.x + randi_range(-p1, p1),
		window_pos.y + randi_range(-p1, p1))
	
		p2 -= 1
		
		if p2 == 0:
			p1 -= 1
			p2 = og_p2
		
		if p1 == 0:
			shaking = "none"
			p1 = 0
			p2 = 0
			og_p1 = 0
			og_p2 = 0
			
			get_window().position = window_pos

func is_odd(x: int) -> bool:
	return x % 2 != 0

func _input(event):
	if event.is_action_pressed("fullscreen"):
		PlayerVars.fs_toggle()

func meta(event: String, param1, param2):
	match event:
		"setpos": # x, y
			Window.position = Vector2i(param1, param2)
		"tweenpos": # pos, time
			var tween = create_tween()
			tween.tween_property(get_window(), "position", param1, param2) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_OUT)
		"setsize": # x, y
			Window.size = Vector2i(param1, param2)
		"shake": # amplifier, duration (frames)
			window_pos = get_window().position
			
			og_p1 = param1
			og_p2 = param2
			p1 = param1
			p2 = param2
			shaking = "yes"
			shaking_timer = param2
		"shakeout": # amplifier, duration per amplifier decrease (frames)
			window_pos = get_window().position
			
			og_p1 = param1
			og_p2 = param2
			p1 = param1
			p2 = param2
			shaking = "smooth"
			shaking_timer = param2

func do_sound(stream: AudioStreamPlayer):
	if PlayerVars.settings["sfx"]:
		if not stream == null:
			stream.play()
		else:
			push_error("Tried to play " + str(stream) + " but is null!")
	else:
		return

func do_music(stream: AudioStreamPlayer):
	if PlayerVars.settings["music"]:
		if not stream == null:
			stream.play()
		else:
			push_error("Tried to play " + str(stream) + " but is null!")
	else:
		return

func do_ut_music(player: AudioStreamPlayer, song: String, looping: bool):
	if not PlayerVars.settings["music"]:
		return
	if player == null:
		print("Couldn't play %s because the player is null!" % song)
		return
	if PlayerVars.other["undertale_detected"] != "": # If we detected the Undertale installation
		print("Trying path " + PlayerVars.other["undertale_detected"] + song)
		var bytes: PackedByteArray = FileAccess.get_file_as_bytes(PlayerVars.other["undertale_detected"] + song)
		if bytes.is_empty():
			print("Couldn't load music!")
			return
		var stream := AudioStreamOggVorbis.load_from_buffer(bytes)
		stream.loop = looping
		player.stream = stream
		player.play()

func transition_room(room):
	var tween_in = create_tween()

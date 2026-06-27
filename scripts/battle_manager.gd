extends Node2D

@onready var battle = $".."
@onready var bui = $BattleUI

var encounter: Encounter

var mercy = [0, 0, 0]
var gains = [0, 0] # exp, G

var plr_turn := true
var battle_ended := false
var base_turn_time := Engine.max_fps * 10
var cur_turn_time := 0

func _process(_delta):
	if not plr_turn:
		if cur_turn_time > 0:
			cur_turn_time -= 1
		else:
			end_turn()

func generate_win_text():
	var old_love = PlayerData.player["love"]
	PlayerData.recalc_stats(PlayerData.player["love"])
	if old_love != PlayerData.player["love"]:
		return "* YOU WIN!\n* You earned %d EXP and %d gold.\n* Your LOVE increased."
	else:
		return "* YOU WIN!\n* You earned %d EXP and %d gold."

func do_act(act):
	$BattleUI/Soul.visible = false
	mercy[1] += encounter["middle_enemy"]["act%d_mercy" % (act + 1)]
	bui.do_textbox(encounter["middle_enemy"]["act%d_message" % (act + 1)])
	bui.flavor_txtbox = false
	bui.txtbox_before_round = true
	print(mercy[1])

func start_battle(e: Encounter):
	encounter = e
	PlayerData.global["cam_active"] = false
	$"../World".visible = false
	$"../World/UI/CosmeticSoul".visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	$"../World".process_mode = Node.PROCESS_MODE_DISABLED
	PlayerData.global["in_battle"] = true
	$BattleUI.update_ui()
	$BattleUI.visible = true
	$"../World/UI/Overlay".visible = false
	Funcs.do_ut_music($SFX/Music, "mus_battle1.ogg", true)

func start_turn():
	plr_turn = false
	$BattleUI/Soul.position = Vector2i(320, 240)
	$BattleUI/Dialogue.visible = false

func end_turn():
	plr_turn = true
	cur_turn_time = base_turn_time
	$BattleUI/Soul.position = Vector2i(320, 240)
	$BattleUI/Dialogue.visible = true
	$BattleUI/Dialogue.typewrite("* The air crackles with\n  [color=red]coding bugs[/color].")

func end_battle_text():
	plr_turn = false
	battle_ended = true
	$SFX/Music.playing = false
	$BattleUI/Dialogue.typewrite(generate_win_text())

func end_battle():
	PlayerData.global["cam_active"] = true
	$"../World".visible = true
	$"../World/UI/CosmeticSoul".visible = true
	$"../World".process_mode = Node.PROCESS_MODE_ALWAYS
	PlayerData.global["in_battle"] = false
	PlayerData.global["interact"] = true
	$BattleUI.visible = false
	$"../World/UI/CosmeticSoul".visible = false
	$"../World/UI/Overlay".visible = false
	if PlayerVars.settings["music"]:
		$"../SFX/Music".playing = true
	process_mode = Node.PROCESS_MODE_DISABLED

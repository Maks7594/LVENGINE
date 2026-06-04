extends Node2D

@onready var battle = $".."
@onready var ui = $BattleUI

var encounter: Encounter

var enemy1_mercy := 0
var enemy2_mercy := 0
var enemy3_mercy := 0

var plr_turn := true
var base_turn_time := Engine.max_fps * 10
var cur_turn_time := 0

func do_act(act):
	$BattleUI/Soul.visible = false
	enemy2_mercy += encounter["middle_enemy"]["act%d_mercy" % (act + 1)]
	ui.do_textbox(encounter["middle_enemy"]["act%d_message" % (act + 1)])
	ui.txtbox_before_round = true
	print(enemy2_mercy)

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
	$BattleUI/Soul.position = Vector2i(320, 240)

func end_battle():
	pass

extends Node2D

@onready var battle = $".."
@onready var ui = $BattleUI

var enemy_mercy := 0

var turn_time = Engine.max_fps * 10
var cur_turn_time = 0

func get_enemy_data(enemy: String, data: String):
	var path = "res://data/enemies/%s.tres" % enemy
	
	if FileAccess.file_exists(path):
		var item_tres = load(path) as Item
		if item_tres:
			return item_tres.get(data)
	
	push_error("Failed to get data %s of enemy %s!" % [data, enemy])
	return "Unknown"


func spare():
	if enemy_mercy == 100:
		end_battle()
	else:
		return

func start_battle():
	PlayerData.global["cam_active"] = false
	$"../World".visible = false
	$"../World/UI/CosmeticSoul".visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	$"../World".process_mode = Node.PROCESS_MODE_DISABLED
	PlayerData.global["in_battle"] = true
	$BattleUI.visible = true
	$"../World/UI/Overlay".visible = false
	Funcs.do_ut_music($SFX/Music, "mus_battle1.ogg", false)

func end_battle():
	pass

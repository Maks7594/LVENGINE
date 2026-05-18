extends Label

func _ready():
	var num = randi() % 3
	
	if num == 0:
		text = "msg1"
	elif num == 1:
		text = "msg2"
	elif num == 2:
		text = "msg3"

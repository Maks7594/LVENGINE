extends NPC

var dialogue = "* Hello, world!\n* You are on %s, I believe.\n* Did I guess correctly?" % OS.get_name()

func interact():
	ui.do_textbox(dialogue)

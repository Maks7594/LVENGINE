extends NPC

var dialogue = [
	"* Multi page dialogue test! \n* Press [lb]Z[rb]!!!",
	"* Line 1\n* Line 2\n* Line 3",
	"* [shake rate=50.0 level=20 connected=0]Did it work?[/shake]"
]

func interact():
	ui.do_multipage_textbox(dialogue, false)

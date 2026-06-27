extends NPC

var dialogue = [
	"* There is some ancient text\n  written here...",
	"* SORRY NOTHING"
]

var has_read = false

func interact():
	ui.do_multipage_textbox(dialogue, false)
	if not has_read:
		has_read = true
		dialogue = [
			"* There's nothing* written here."
		]

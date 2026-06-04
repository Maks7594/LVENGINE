extends Trigger

func _on_body_entered(body):
	if body.name == "Player":
		var dialogue = [
			"* Trigger jumpscare",
			"* boo"
		]
		
		ui.do_multipage_textbox(dialogue, false)

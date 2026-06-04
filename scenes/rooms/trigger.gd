extends Trigger

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		ui.do_textbox("* Trigger jumpscare\n* boo")
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)
		$CollisionShape2D.set_deferred("disabled", true)

extends StaticBody2D

var ran = false

func interact():
	if not ran:
		ran = true
		$Sprite2D.play("disappear")
		$SFX.play()
		
		var tween = create_tween()
		tween.tween_property($Sprite2D, "modulate:a", 0.0, 0.5)
		
		await tween.finished
		$CollisionShape2D.disabled = true

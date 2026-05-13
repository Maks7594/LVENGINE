extends StaticBody2D

func interact():
	print("showing text")
	$"../UI".do_text("* g o d o t")
	print($"../UI".visible)
	print($"../UI/Textbox".visible)

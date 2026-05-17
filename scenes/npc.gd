extends StaticBody2D

func interact():
	print("showing text")
	print($"../UI".visible)
	$"../UI/Textbox".visible = true
	$"../UI".do_textbox("* g o d o t")
	

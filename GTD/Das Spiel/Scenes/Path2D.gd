extends Path2D

func _on_Timer_timeout():
	var enemy = preload("res://Scenes/Dreieck.tscn").instance()
	add_child(enemy)

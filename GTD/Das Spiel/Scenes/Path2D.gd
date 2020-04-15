extends Path2D

func _on_Timer_timeout():
	var enemy = preload("res://Scenes/PathFollow2D.tscn").instance()
	add_child(enemy)

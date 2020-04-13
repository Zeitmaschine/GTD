extends PathFollow2D

export (float) var Speed = 200

func _physics_process(delta):
	offset += Speed * delta
	
	if unit_offset >= 1:
		queue_free()

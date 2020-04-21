extends PathFollow2D

export (float) var speed = 300

func _physics_process(delta):
	offset += speed * delta
	
	if unit_offset >= 1:
		queue_free()

func hit():
	queue_free()
	


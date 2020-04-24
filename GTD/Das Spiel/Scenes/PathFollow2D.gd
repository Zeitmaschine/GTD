extends PathFollow2D

export (float) var speed = 300

func _physics_process(delta):
	var damage = 1
	offset += speed * delta

	if unit_offset >= 1:
		get_parent().get_parent().remove_health(get_child(1).getHP())
		queue_free()

func hit():
	queue_free()

func damage():
	queue_free()
	

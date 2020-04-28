extends PathFollow2D

export (float) var speed
export var hp = 1

func _ready():
	get_child(0).hp = hp

func _physics_process(delta):
	checkSpeed()
	
	offset += speed * delta

	if unit_offset >= 1:
		get_parent().get_parent().remove_health(get_child(0).getHP())
		queue_free()

func hit():
	queue_free()

func damage():
	queue_free()
	
func checkSpeed():
	speed = 100 + (get_child(0).getHP() * 50)

func setHP(newHp):
	hp = newHp

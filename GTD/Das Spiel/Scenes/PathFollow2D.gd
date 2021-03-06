extends PathFollow2D

export (float) var speed
export var hp = 1

func _ready():
	get_child(0).hp = hp

func _physics_process(delta):
	checkSpeed()
	
	offset += speed * delta

	if unit_offset >= 1:
		get_tree().get_current_scene().get_node("GameHandler").remove_health(get_child(0).getHP())
		queue_free()

func hit(amount):
	get_child(0).hit(amount)

func damage():
	get_tree().get_current_scene().get_node("GameHandler").enemycount -= 1
	queue_free()
	
func checkSpeed():
	if(get_child(0).stun):
		speed = 0
	
	else:
		if get_tree().get_current_scene().get_node("GameHandler").fasterTime == true:
			speed = 2 * (30 + (get_child(0).getHP() * 50)) * get_child(0).speed
		else:
			speed = (30 + (get_child(0).getHP() * 50)) * get_child(0).speed

func setHP(newHp):
	hp = newHp

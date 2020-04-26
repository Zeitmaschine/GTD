extends Label

export var health = 250

func _ready():
	text = str(health)
	
func _process(delta):
	text = str(health)
	if (health < 0):
		text = str(0)

func getHealth():
	return health
	
func setHealth(healthy):
	health = healthy

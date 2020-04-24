extends Label

export var health = 250

func _ready():
	text = str(health)
	
func _process(delta):
	text = str(health)
	
func getHealth():
	return health
	
func setHealth(healthy):
	health = healthy

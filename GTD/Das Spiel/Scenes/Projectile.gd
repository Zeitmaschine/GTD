extends KinematicBody2D

export var damage = 1
export var velocity = Vector2(360,360)
export var speed = 200

func _ready():
	pass

func _process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		hit()

func hit():
	queue_free()


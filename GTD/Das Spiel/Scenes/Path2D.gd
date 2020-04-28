extends Path2D
var enemy_spawn_hp

func _on_Timer_timeout():
	var enemy = preload("res://Scenes/PathFollow2D.tscn").instance()
	enemy.setHP(enemy_spawn_hp)
	add_child(enemy)
	
func setEnemySpawnHp(hp):
	enemy_spawn_hp = hp

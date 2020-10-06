extends Node2D

#Uni-Variablen
export var upgrade1unlock = false
export var upgrade2unlock = false

#Status
export var waverunning = false
export var wave = 1
export var money = 1350 #Startgeld
export var healthy = 100
export var enemycount = 0 # Anzahl der Gegner auf dem Spiel (Grundlage, für Rundenenden, wo alle Gegner zerstört sein müssen.)
var moneyinterface
var healthinterface
var healthdeath
var waveinterface
var max_universitaet = false
var unigekauft = false
var unitext
var pauseAllowed = 0
var victory = false
var fasterTime = false



#Preloading
var mathematiker = preload("res://Scenes/Mathematiker.tscn")
var informatiker = preload("res://Scenes/Informatiker.tscn")
var mathebombenturm = preload("res://Scenes/MatheBombenTurm.tscn")
var winkelninja = preload("res://Scenes/Winkelninja.tscn")
var universitaet = preload("res://Scenes/Universität.tscn")
var physiker = preload("res://Scenes/Physiker.tscn")


#Preise der Türme
export var mathematikerPrice = 500
export var informatikerPrice = 700
export var bombenturmPrice = 900
export var winkelninjaPrice = 880
export var uniPrice = 500
export var physikerPrice = 250

#Platzierung
var placemode = false



#Verdienen von Geld
func add_money(ammount, death):
	money += ammount
	if death == true:
		get_tree().get_current_scene().get_node("Die").play()

#Geld durch Verbesserungen
func add_extramoney(ammount):
	if waverunning == true:
		money += ammount

#Leben durch die Mensa
func add_extrahealth(ammount):
	healthy += ammount

#Lebensabzug
func remove_health(ammount):
	healthy -= ammount
	get_tree().get_current_scene().get_node("Life_Lost").play()

#Implementierung der Interfaces
func _ready():
	moneyinterface = get_tree().get_current_scene().get_node("InterfaceLayer/Interface/StatsMenu/HBoxContainer/Moneybar/MarginContainer/Backround/Count")
	healthinterface = get_tree().get_current_scene().get_node("InterfaceLayer/Interface/StatsMenu/HBoxContainer/Healthbar/MarginContainer/Backround/Health")
	waveinterface = get_tree().get_current_scene().get_node("InterfaceLayer/Interface/RundenContainer/Rundenzahl")
	healthdeath = get_tree().get_current_scene().get_node("InterfaceLayer/Interface/GameOverLayer/GameOver")
	unigekauft = get_tree().get_current_scene().get_node("InterfaceLayer/Interface/ShopLayer/ShopMenu")
	unitext = get_tree().get_current_scene().get_node("InterfaceLayer/Interface/ShopLayer/ShopMenu/ShopBackround/UniversitaetButton/UniversitaetText")

#Hochzählen der Werte + Überprüfung von Input
func _process(delta):
	moneyinterface.setCoins(money)
	healthinterface.setHealth(healthy)
	healthdeath.setHealth(healthy)
	waveinterface.setWave(wave)
	wave = get_tree().get_current_scene().get_node("Rounds").wave
	
	#Debug-Knopf
	if Input.is_action_just_pressed("Hotkey0"):
		money += 1000
	
	if Input.is_action_just_pressed("spacebar") && waverunning == false && victory == false:
		waverunning = true
	
	if waverunning == true:
		get_tree().get_current_scene().get_node("Rounds").checkWave()
	else:
		get_tree().get_current_scene().get_node("Path2D/Timer").stop()

	if Input.is_action_just_pressed("Hotkey1"):
		if money >= mathematikerPrice:
			add_mathematiker()
		else:
			get_tree().get_current_scene().get_node("Buy_failed").play()

	if Input.is_action_just_pressed("Hotkey2"):
		if money >= informatikerPrice:
			add_informatiker()
		else:
			get_tree().get_current_scene().get_node("Buy_failed").play()
			

	if Input.is_action_just_pressed("Hotkey3"):
		if money >= bombenturmPrice:
			add_mathebombenturm()
		else:
			get_tree().get_current_scene().get_node("Buy_failed").play()

	if Input.is_action_just_pressed("Hotkey4"):
		if money >= winkelninjaPrice:
			add_winkelninja()
		else:
			get_tree().get_current_scene().get_node("Buy_failed").play()

	if Input.is_action_just_pressed("Hotkey5"):
		if money >= uniPrice  && max_universitaet == false:
			get_tree().get_current_scene().get_node("InterfaceLayer/Interface/ShopLayer/ShopMenu").unigekauft = true
			max_universitaet = true
			unitext.text = "Gekauft"
			add_universitaet()
		else:
			get_tree().get_current_scene().get_node("Buy_failed").play()
			
	
	if Input.is_action_just_pressed("Hotkey6"):
		if money >= uniPrice:
			add_physiker()
		else:
			get_tree().get_current_scene().get_node("Buy_failed").play()
			


#Mathermatiker platzieren
func add_mathematiker():
	if placemode == false:
		placemode = true
		var mathematiker_instance = mathematiker.instance()
		add_child(mathematiker_instance)
		var originalcolor = mathematiker_instance.get_node("Sprite_Mathematiker").modulate
		while (true):
			yield(get_tree().create_timer(0.001), "timeout")
			mathematiker_instance.position = get_global_mouse_position()
			if mathematiker_instance.get_node("Mathematiker_Area").get_overlapping_bodies().size() > 1:
				mathematiker_instance.get_node("Sprite_Mathematiker").modulate = Color(255,0,0,255)
				mathematiker_instance.get_node("Range_Sprite").modulate = Color(50,0,0,0)
			
			if mathematiker_instance.get_node("Mathematiker_Area").get_overlapping_bodies().size() == 1:
				mathematiker_instance.get_node("Sprite_Mathematiker").modulate = originalcolor
				mathematiker_instance.get_node("Range_Sprite").modulate = originalcolor
			
			if Input.is_action_just_pressed("left_click") && mathematiker_instance.get_node("Mathematiker_Area").get_overlapping_bodies().size() == 1:
				money = money - mathematikerPrice
				get_tree().get_current_scene().get_node("Buy").play()
				break
			
			if Input.is_action_just_pressed("left_click") && mathematiker_instance.get_node("Mathematiker_Area").get_overlapping_bodies().size() > 1:
				get_tree().get_current_scene().get_node("Buy_failed").play()
			
			if Input.is_action_just_pressed("right_click"):
				get_tree().get_current_scene().get_node("Buy_failed").play()
				mathematiker_instance.queue_free()
				break
		mathematiker_instance.placed = true
		placemode = false

#Informatiker platzieren
func add_informatiker():
	if placemode == false:
		placemode = true
		var informatiker_instance = informatiker.instance()
		add_child(informatiker_instance)
		var originalcolor = informatiker_instance.get_node("Sprite_Informatiker").modulate
		while (true):
			yield(get_tree().create_timer(0.001), "timeout")
			informatiker_instance.position = get_global_mouse_position()
			if informatiker_instance.get_node("Informatiker_Area").get_overlapping_bodies().size() > 1:
				informatiker_instance.get_node("Sprite_Informatiker").modulate = Color(255,0,0,255)
				informatiker_instance.get_node("Range_Sprite").modulate = Color(50,0,0,0)
			
			if informatiker_instance.get_node("Informatiker_Area").get_overlapping_bodies().size() == 1:
				informatiker_instance.get_node("Sprite_Informatiker").modulate = originalcolor
				informatiker_instance.get_node("Range_Sprite").modulate = originalcolor
			
			if Input.is_action_just_pressed("left_click") && informatiker_instance.get_node("Informatiker_Area").get_overlapping_bodies().size() == 1:
				money = money - informatikerPrice
				get_tree().get_current_scene().get_node("Buy").play()
				break
			
			if Input.is_action_just_pressed("left_click") && informatiker_instance.get_node("Informatiker_Area").get_overlapping_bodies().size() > 1:
				get_tree().get_current_scene().get_node("Buy_failed").play()
			
			if Input.is_action_just_pressed("right_click"):
				get_tree().get_current_scene().get_node("Buy_failed").play()
				informatiker_instance.queue_free()
				break
		informatiker_instance.placed = true
		placemode = false
		

#Bombenturm platzieren
func add_mathebombenturm():
	if placemode == false:
		placemode = true
		var mathebombenturm_instance = mathebombenturm.instance()
		add_child(mathebombenturm_instance)
		var originalcolor = mathebombenturm_instance.get_node("Sprite_MatheBombenTurm").modulate
		while (true):
			yield(get_tree().create_timer(0.001), "timeout")
			mathebombenturm_instance.position = get_global_mouse_position()
			if mathebombenturm_instance.get_node("MatheBombenTurm_Area").get_overlapping_bodies().size() > 1:
				mathebombenturm_instance.get_node("Sprite_MatheBombenTurm").modulate = Color(255,0,0,255)
				mathebombenturm_instance.get_node("Range_Sprite").modulate = Color(50,0,0,0)
			
			if mathebombenturm_instance.get_node("MatheBombenTurm_Area").get_overlapping_bodies().size() == 1:
				mathebombenturm_instance.get_node("Sprite_MatheBombenTurm").modulate = originalcolor
				mathebombenturm_instance.get_node("Range_Sprite").modulate = originalcolor
			
			if Input.is_action_just_pressed("left_click") && mathebombenturm_instance.get_node("MatheBombenTurm_Area").get_overlapping_bodies().size() == 1:
				money = money - bombenturmPrice
				get_tree().get_current_scene().get_node("Buy").play()
				break
			
			if Input.is_action_just_pressed("left_click") && mathebombenturm_instance.get_node("MatheBombenTurm_Area").get_overlapping_bodies().size() > 1:
				get_tree().get_current_scene().get_node("Buy_failed").play()
			
			if Input.is_action_just_pressed("right_click"):
				get_tree().get_current_scene().get_node("Buy_failed").play()
				mathebombenturm_instance.queue_free()
				break
		mathebombenturm_instance.placed = true
		placemode = false
	
#Winkelninja platzieren
func add_winkelninja():
	if placemode == false:
		placemode = true
		var winkelninja_instance = winkelninja.instance()
		var this_instance = add_child(winkelninja_instance)
		var originalcolor = winkelninja_instance.get_node("Sprite_Winkelninja").modulate
		while (true):
			yield(get_tree().create_timer(0.001), "timeout")
			winkelninja_instance.position = get_global_mouse_position()
			if winkelninja_instance.get_node("Winkelninja_Area").get_overlapping_bodies().size() > 1:
				winkelninja_instance.get_node("Sprite_Winkelninja").modulate = Color(255,0,0,255)
				winkelninja_instance.get_node("Range_Sprite").modulate = Color(50,0,0,0)
			
			if winkelninja_instance.get_node("Winkelninja_Area").get_overlapping_bodies().size() == 1:
				winkelninja_instance.get_node("Sprite_Winkelninja").modulate = originalcolor
				winkelninja_instance.get_node("Range_Sprite").modulate = originalcolor
			
			if Input.is_action_just_pressed("left_click") && winkelninja_instance.get_node("Winkelninja_Area").get_overlapping_bodies().size() == 1:
				money = money - winkelninjaPrice
				get_tree().get_current_scene().get_node("Buy").play()
				break
			
			if Input.is_action_just_pressed("left_click") && winkelninja_instance.get_node("Winkelninja_Area").get_overlapping_bodies().size() > 1:
				get_tree().get_current_scene().get_node("Buy_failed").play()
			
			if Input.is_action_just_pressed("right_click"):
				get_tree().get_current_scene().get_node("Buy_failed").play()
				winkelninja_instance.queue_free()
				break
		winkelninja_instance.placed = true
		placemode = false
	
#Uni platzieren
func add_universitaet():
	if placemode == false:
		placemode = true
		var universitaet_instance = universitaet.instance()
		var this_instance = add_child(universitaet_instance)
		var originalcolor = universitaet_instance.get_node("Sprite_Universitaet").modulate
		while (true):
			yield(get_tree().create_timer(0.001), "timeout")
			universitaet_instance.position = get_global_mouse_position()
			if universitaet_instance.get_node("Universität_Area").get_overlapping_bodies().size() > 1:
				universitaet_instance.get_node("Sprite_Universitaet").modulate = Color(255,0,0,255)
			
			if universitaet_instance.get_node("Universität_Area").get_overlapping_bodies().size() == 1:
				universitaet_instance.get_node("Sprite_Universitaet").modulate = originalcolor
			
			if Input.is_action_just_pressed("left_click") && universitaet_instance.get_node("Universität_Area").get_overlapping_bodies().size() == 1:
				money = money - uniPrice
				get_tree().get_current_scene().get_node("Buy").play()
				get_tree().get_current_scene().get_node("InterfaceLayer/Interface/ShopLayer/ShopMenu").unigekauft = true
				max_universitaet = true
				break
			
			if Input.is_action_just_pressed("left_click") && universitaet_instance.get_node("Universität_Area").get_overlapping_bodies().size() > 1:
				get_tree().get_current_scene().get_node("Buy_failed").play()
			
			if Input.is_action_just_pressed("right_click"):
				max_universitaet = false
				get_tree().get_current_scene().get_node("InterfaceLayer/Interface/ShopLayer/ShopMenu").unigekauft = false
				unitext.text = "500$"
				get_tree().get_current_scene().get_node("Buy_failed").play()
				universitaet_instance.queue_free()
				break
		universitaet_instance.placed = true
		placemode = false
		
func add_physiker():
	if placemode == false:
		placemode = true
		var physiker_instance = physiker.instance()
		add_child(physiker_instance)
		var originalcolor = physiker_instance.get_node("Sprite_Physiker").modulate
		while (true):
			yield(get_tree().create_timer(0.001), "timeout")
			physiker_instance.position = get_global_mouse_position()
			if physiker_instance.get_node("Physiker_Area").get_overlapping_bodies().size() > 1:
				physiker_instance.get_node("Sprite_Physiker").modulate = Color(255,0,0,255)
				physiker_instance.get_node("Range_Sprite").modulate = Color(50,0,0,0)
			
			if physiker_instance.get_node("Physiker_Area").get_overlapping_bodies().size() == 1:
				physiker_instance.get_node("Sprite_Physiker").modulate = originalcolor
				physiker_instance.get_node("Range_Sprite").modulate = originalcolor
			
			if Input.is_action_just_pressed("left_click") && physiker_instance.get_node("Physiker_Area").get_overlapping_bodies().size() == 1:
				money = money - physikerPrice
				get_tree().get_current_scene().get_node("Buy").play()
				break
			
			if Input.is_action_just_pressed("left_click") && physiker_instance.get_node("Physiker_Area").get_overlapping_bodies().size() > 1:
				get_tree().get_current_scene().get_node("Buy_failed").play()
			
			if Input.is_action_just_pressed("right_click"):
				get_tree().get_current_scene().get_node("Buy_failed").play()
				physiker_instance.queue_free()
				break
		physiker_instance.placed = true
		placemode = false

#Freischaltung des Upgrades 1
func setUpgrade1Unlock(upgrade11unlock):
	upgrade1unlock = upgrade11unlock

#Überprüfung des Upgrades 1
func getUpgrade1Unlock():
	return upgrade1unlock

#Freischaltung des Upgrades 2
func setUpgrade2Unlock(upgrade22unlock):
	upgrade2unlock = upgrade22unlock

#Überprüfung des Upgrades 2
func getUpgrade2Unlock():
	return upgrade2unlock

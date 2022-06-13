extends Node2D


export (PackedScene) var player
export (PackedScene) var bomba
export (PackedScene) var expansion
export (PackedScene) var expansion_f
export (PackedScene) var item_bomb
export (PackedScene) var item_expansion
export (PackedScene) var item_puerta
export (PackedScene) var enemy1

# Called when the node enters the scene tree for the first time.
func _ready():
	gamehandler.load_level()
	gamehandler.spawn()


func _on_Timer_timeout():
	if(gamehandler.tiempo_actual > 0):
		gamehandler.tiempo_actual -= 1
		gamehandler.update_time()
		if(gamehandler.tiempo_actual == 100):
			gamehandler.play_bgm(2)
			gamehandler.stop_bgm(1)
			gamehandler.play_sfx(6)
	else:
		if(get_tree().get_nodes_in_group("enemy").size() < 5):
			var newenemy = enemy1.instance()
			get_tree().get_nodes_in_group("nivel")[0].add_child(newenemy)
			var lista_enemigos = get_tree().get_nodes_in_group("spawn_e")
			lista_enemigos.shuffle()
			newenemy.global_position = lista_enemigos[0].global_position
			

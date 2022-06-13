extends Node


var nivel = 1
var vidas = 3
var tiempo_actual = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn():
	if(vidas > 0):
		var newplayer = get_tree().get_nodes_in_group("main")[0].player.instance()
		newplayer.global_position = get_tree().get_nodes_in_group("spawn_j")[0].global_position
		get_tree().get_nodes_in_group("nivel")[0].add_child(newplayer)
		
func load_level():
	var nvl_path =  load("res://Scenes/nivel"+ str(nivel) + ".tscn")
	var nivel = nvl_path.instance()
	get_tree().get_nodes_in_group("main")[0].add_child(nivel)
	update_enemys()
	update_lifes()
	tiempo_actual = 200
	update_time()
	stop_bgm(2)
	play_bgm(1)
	
func update_enemys():
	get_tree().get_nodes_in_group("enemigos")[0].text = String(get_tree().get_nodes_in_group("enemy").size())
	
func update_time():
	get_tree().get_nodes_in_group("tiempo")[0].text = String(tiempo_actual) 
	
func update_lifes():
	get_tree().get_nodes_in_group("vidas")[0].text = String(vidas)
	
func play_bgm(num):
	get_tree().get_nodes_in_group("bgm")[0].get_node(String(num)).play()
	
func stop_bgm(num):
	get_tree().get_nodes_in_group("bgm")[0].get_node(String(num)).stop()
	
func play_sfx(num):
	if(!get_tree().get_nodes_in_group("sfx")[0].get_node(String(num)).is_playing()):
		get_tree().get_nodes_in_group("sfx")[0].get_node(String(num)).play()
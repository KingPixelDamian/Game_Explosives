extends Area2D

export (int) var id
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_item_body_entered(body):
	if(body.is_in_group("player")):
		match(id):
			0: #Bomba
				get_tree().get_nodes_in_group("player")[0].max_bomb += 1
				gamehandler.play_sfx(5)
			1: #Expansion
				get_tree().get_nodes_in_group("player")[0].expansion += 1
				gamehandler.play_sfx(5)
			2: #Puerta
				if(get_tree().get_nodes_in_group("enemy").size() > 0):
					return
				else:
					gamehandler.stop_bgm(1)
					gamehandler.stop_bgm(2)
					gamehandler.play_bgm(3)
					yield(get_tree().create_timer(4.0),"timeout")
					gamehandler.nivel += 1
					get_tree().get_nodes_in_group("nivel")[0].queue_free()
					gamehandler.load_level()
		queue_free()

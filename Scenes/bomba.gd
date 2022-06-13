extends Node2D

export (float) var duracion
var bombeos = 0
var exploto = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var numg = Vector2(int(global_position.x / 16), int(global_position.y / 16))
	global_position = Vector2(numg.x * 16-8, numg.y * 16)
	$Abajo.add_to_group(name)
	$Arriba.add_to_group(name)
	$Izquierda.add_to_group(name)
	$Derecha.add_to_group(name)
	var raycasts = get_tree().get_nodes_in_group(name)
	for r in raycasts:
		r.add_exception(get_tree().get_nodes_in_group("player")[0])
		r.cast_to.y = 16 * get_tree().get_nodes_in_group("player")[0].expansion
	
	
	
func _physics_process(delta):
	if(exploto):
		check_raycast()


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "explosion"):
		queue_free()
	elif(anim_name == "idle"):
		bombeos += 1
		if(bombeos == 3): #EXPLOTA LA BOMBA
			$AnimationPlayer.play("explosion")
			bombeos = 0
			check_raycast()
			generar_expansion()
			exploto = true
			var raycasts = get_tree().get_nodes_in_group(name)
			for r in raycasts:
				r.remove_exception(get_tree().get_nodes_in_group("player")[0])
		else:
			$AnimationPlayer.play("idle")

func generar_expansion():
	var nivel = get_tree().get_nodes_in_group("nivel")[0]
	var cas_act = 1
	#EXPANSION DERECHA
	var n_cas = $Derecha.cast_to.y / 16
	for i in n_cas:
		if(n_cas == cas_act && !$Derecha.is_colliding()):
			var exp_f = get_tree().get_nodes_in_group("main")[0].expansion_f.instance()
			nivel.add_child(exp_f)
			exp_f.global_position = Vector2(global_position.x + cas_act * 16, global_position.y)
		elif(n_cas > cas_act):
			var pos_f = global_position.x + cas_act * 16
			if(!$Derecha.is_colliding() || ($Derecha.is_colliding() && $Derecha.get_collision_point().x +8 > pos_f) ):
				var expan = get_tree().get_nodes_in_group("main")[0].expansion.instance()
				nivel.add_child(expan)
				expan.global_position = Vector2(pos_f, global_position.y)
		cas_act += 1
	#EXPANSION IZQUIERDA
	cas_act = 1
	n_cas = $Izquierda.cast_to.y / 16
	for i in n_cas:
		if(n_cas == cas_act && !$Izquierda.is_colliding()):
			var exp_f = get_tree().get_nodes_in_group("main")[0].expansion_f.instance()
			nivel.add_child(exp_f)
			exp_f.global_position = Vector2(global_position.x - cas_act * 16, global_position.y)
			exp_f.get_node("Sprite").flip_h = true
		elif(n_cas > cas_act):
			var pos_f = global_position.x - cas_act * 16
			if(!$Izquierda.is_colliding() || ($Izquierda.is_colliding() && $Izquierda.get_collision_point().x -8 > pos_f) ):
				var expan = get_tree().get_nodes_in_group("main")[0].expansion.instance()
				nivel.add_child(expan)
				expan.global_position = Vector2(pos_f, global_position.y)
				expan.get_node("Sprite").flip_h = true
		cas_act += 1
	#EXPANSION ARRIBA
	cas_act = 1
	n_cas = $Arriba.cast_to.y / 16
	for i in n_cas:
		if(n_cas == cas_act && !$Arriba.is_colliding()):
			var exp_f = get_tree().get_nodes_in_group("main")[0].expansion_f.instance()
			nivel.add_child(exp_f)
			exp_f.global_position = Vector2(global_position.x, global_position.y - cas_act * 16)
			exp_f.get_node("Sprite").rotation_degrees = 270
		elif(n_cas > cas_act):
			var pos_f = global_position.y - cas_act * 16
			if(!$Arriba.is_colliding() || ($Arriba.is_colliding() && $Arriba.get_collision_point().y -8 > pos_f) ):
				var expan = get_tree().get_nodes_in_group("main")[0].expansion.instance()
				nivel.add_child(expan)
				expan.global_position = Vector2(global_position.x, pos_f)
				expan.get_node("Sprite").rotation_degrees = 270
		cas_act += 1
	#EXPANSION ABAJO
	cas_act = 1
	n_cas = $Abajo.cast_to.y / 16
	for i in n_cas:
		if(n_cas == cas_act && !$Abajo.is_colliding()):
			var exp_f = get_tree().get_nodes_in_group("main")[0].expansion_f.instance()
			nivel.add_child(exp_f)
			exp_f.global_position = Vector2(global_position.x, global_position.y + cas_act * 16)
			exp_f.get_node("Sprite").rotation_degrees = 90
		elif(n_cas > cas_act):
			var pos_f = global_position.y + cas_act * 16
			if(!$Abajo.is_colliding() || ($Abajo.is_colliding() && $Abajo.get_collision_point().y +8 > pos_f) ):
				var expan = get_tree().get_nodes_in_group("main")[0].expansion.instance()
				nivel.add_child(expan)
				expan.global_position = Vector2(global_position.x, pos_f)
				expan.get_node("Sprite").rotation_degrees = 90
		cas_act += 1

func check_raycast():
	var raycasts = get_tree().get_nodes_in_group(name)
	for r in raycasts:
		if(r.is_colliding()):
			var col = r.get_collider()
			if(col.is_in_group("bloque") && !exploto):
				var modificador = Vector2()
				if(r.name == "Abajo"):
					modificador.y = 8
				elif(r.name == "Arriba"):
					modificador.y = -8
				elif(r.name == "Izquierda"):
					modificador.x = -8
				elif(r.name == "Derecha"):
					modificador.x = 8
				var pc = r.get_collision_point() + modificador
				var tilemap = get_tree().get_nodes_in_group("tilemap")[0]
				pc = tilemap.world_to_map(pc)
				if(tilemap.get_cellv(pc) == 1):
					var newib = get_tree().get_nodes_in_group("main")[0].item_bomb.instance()
					newib.global_position = r.get_collision_point() + modificador
					get_tree().get_nodes_in_group("nivel")[0].add_child(newib)
				elif(tilemap.get_cellv(pc) == 2):
					var newib = get_tree().get_nodes_in_group("main")[0].item_expansion.instance()
					newib.global_position = r.get_collision_point() + modificador
					get_tree().get_nodes_in_group("nivel")[0].add_child(newib)
				elif(tilemap.get_cellv(pc) == 3):
					var newib = get_tree().get_nodes_in_group("main")[0].item_puerta.instance()
					newib.global_position = r.get_collision_point() + modificador
					get_tree().get_nodes_in_group("nivel")[0].add_child(newib)
				tilemap.set_cellv(pc,-1)
			elif(col.is_in_group("player") || col.is_in_group("enemy")):
				col.muerte()
				
extends KinematicBody2D

export (float) var vel_mov
export (int) var probabilidad_mov
var vel_act = Vector2()
var puede_animacion_walk = true
var change_direction = true

enum estados {ninguno, mov_der, mov_izq, mov_arr, mov_ab, muerto}

var estado_actual = estados.mov_der

# Called when the node enters the scene tree for the first time.
func _ready():
	$Abajo.add_to_group(get_parent().name)
	$Arriba.add_to_group(get_parent().name)
	$Izquierda.add_to_group(get_parent().name)
	$Derecha.add_to_group(get_parent().name)
	cambiar_direccion(randi()%3)
	
func _physics_process(delta):
	
	if(estado_actual != estados.muerto):
		vel_act = Vector2(0,0)
		
		if(estado_actual == estados.mov_izq):
			vel_act.x = -vel_mov
			if(puede_animacion_walk):
				$Timer.start()
				if($Sprite.frame == 212):
					$Sprite.frame = 210
				else:
					$Sprite.frame += 1
			puede_animacion_walk = false
		elif(estado_actual == estados.mov_der):
			vel_act.x = vel_mov
			if(puede_animacion_walk):
				$Timer.start()
				if($Sprite.frame == 212):
					$Sprite.frame = 210
				else:
					$Sprite.frame += 1
			puede_animacion_walk = false
		elif(estado_actual == estados.mov_arr):
			vel_act.y = -vel_mov
			if(puede_animacion_walk):
				$Timer.start()
				puede_animacion_walk = false
				if($Sprite.frame == 212):
					$Sprite.frame = 210
				else:
					$Sprite.frame += 1
		elif(estado_actual == estados.mov_ab):
			vel_act.y = vel_mov
			if(puede_animacion_walk):
				$Timer.start()
				puede_animacion_walk = false
				if($Sprite.frame == 212):
					$Sprite.frame = 210
				else:
					$Sprite.frame += 1
					
		var col = move_and_collide(vel_act*delta)
		
		if(col != null):
			col = col.collider
			if(col.is_in_group("pared") || col.is_in_group("bomba")):
				if(estado_actual == estados.mov_izq):
					cambiar_direccion(1)
				elif(estado_actual == estados.mov_der):
					cambiar_direccion(0)
				elif(estado_actual == estados.mov_ab):
					cambiar_direccion(2)
				elif(estado_actual == estados.mov_arr):
					cambiar_direccion(3)
		else:
			if(change_direction):
				var numg = Vector2(int(global_position.x / 16), int(global_position.y / 16))
				numg = Vector2(numg.x * 16-8, numg.y * 16-16)
				#print(numg.distance_to(global_position))
				if(numg.distance_to(global_position) < 1):
					check_raycast()
					change_direction = false
					yield(get_tree().create_timer(0.5),"timeout")
					change_direction = true


func cambiar_direccion(num):
	
	var resultado = randi()%100
	
	if(probabilidad_mov > resultado):
		
		match(num):
			0:
				estado_actual = estados.mov_izq
				$Sprite.frame = 210
				$Sprite.flip_h = true
			1:
				estado_actual = estados.mov_der
				$Sprite.frame = 210
				$Sprite.flip_h = false
			2:
				estado_actual = estados.mov_arr
				$Sprite.frame = 210
			3:
				estado_actual = estados.mov_ab
				$Sprite.frame = 210

func _on_Timer_timeout():
	puede_animacion_walk = true
	
func muerte():
	gamehandler.play_sfx(6)
	$AnimationPlayer.play("muerte")
	estado_actual = estados.muerto
	$CollisionShape2D.disabled = true


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "muerte"):
		remove_from_group("enemy")
		gamehandler.update_enemys()
		queue_free()

func check_raycast():
	var raycasts = get_tree().get_nodes_in_group(get_parent().name)
	for r in raycasts:
		if(r.is_colliding()):
			var col = r.get_collider()
			if(col.is_in_group("player")):
				pass
		else:
			if(estado_actual != estados.mov_der && estado_actual != estados.mov_izq && r.name == "Izquierda"):
				cambiar_direccion(0)
				return
			elif(estado_actual != estados.mov_izq && estado_actual != estados.mov_der && r.name == "Derecha"):
				cambiar_direccion(1)
				return
			elif(estado_actual != estados.mov_arr && estado_actual != estados.mov_ab && r.name == "Abajo"):
				cambiar_direccion(3)
				return
			elif(estado_actual != estados.mov_ab && estado_actual != estados.mov_arr && r.name == "Arriba"):
				cambiar_direccion(2)
				return
			
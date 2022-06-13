extends KinematicBody2D

export (float) var vel_mov
var max_bomb = 0
var expansion = 1
var vel_act = Vector2()
var puede_animacion_walk = true
var puede_bombear = true

enum estados {ninguno, mov_der, mov_izq, mov_arr, mov_ab, muerto}

var estado_actual = estados.ninguno

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	
	if(estado_actual != estados.muerto):
		vel_act = Vector2(0,0)
		
		if(Input.is_action_pressed("tecla_a")):
			if(estado_actual != estados.mov_izq):
				estado_actual = estados.mov_izq
				$Sprite.frame = 0
			
			vel_act.x = -vel_mov
			if(puede_animacion_walk):
				$Timer.start()
				if($Sprite.frame == 2):
					$Sprite.frame = 0
				else:
					$Sprite.frame += 1
				gamehandler.play_sfx(1)
			$Sprite.flip_h = false
			puede_animacion_walk = false
		elif(Input.is_action_pressed("tecla_d")):
			if(estado_actual != estados.mov_der):
				estado_actual = estados.mov_der
				$Sprite.frame = 0
			vel_act.x = vel_mov
			if(puede_animacion_walk):
				$Timer.start()
				if($Sprite.frame == 2):
					$Sprite.frame = 0
				else:
					$Sprite.frame += 1
				gamehandler.play_sfx(1)
			$Sprite.flip_h = true
			puede_animacion_walk = false
		elif(Input.is_action_pressed("tecla_w")):
			if(estado_actual != estados.mov_arr):
				estado_actual = estados.mov_arr
				$Sprite.frame = 17
			vel_act.y = -vel_mov
			if(puede_animacion_walk):
				$Timer.start()
				puede_animacion_walk = false
				if($Sprite.frame == 19):
					$Sprite.frame = 17
				else:
					$Sprite.frame += 1
				gamehandler.play_sfx(2)
		elif(Input.is_action_pressed("tecla_s")):
			if(estado_actual != estados.mov_ab):
				estado_actual = estados.mov_ab
				$Sprite.frame = 3
			vel_act.y = vel_mov
			if(puede_animacion_walk):
				$Timer.start()
				puede_animacion_walk = false
				if($Sprite.frame == 5):
					$Sprite.frame = 3
				else:
					$Sprite.frame += 1
				gamehandler.play_sfx(2)
					
		if(Input.is_action_just_pressed("tecla_espacio") && puede_bombear):
			var newbomb = get_tree().get_nodes_in_group("main")[0].bomba.instance()
			newbomb.global_position = $c.global_position
			get_tree().get_nodes_in_group("nivel")[0].add_child(newbomb)
			puede_bombear = false
			gamehandler.play_sfx(3)
		elif(!puede_bombear):
			check_bombs()
			
			
		move_and_collide(vel_act*delta)

func check_bombs():
	var cantbombas = get_tree().get_nodes_in_group("bomba").size()
	if(cantbombas == max_bomb):
		puede_bombear = true

func _on_Timer_timeout():
	puede_animacion_walk = true
	
func muerte():
	$AnimationPlayer.play("muerte")
	estado_actual = estados.muerto
	$CollisionShape2D.disabled = true
	gamehandler.vidas -= 1
	gamehandler.update_lifes()


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "muerte"):
		$cam.current = false
		gamehandler.spawn()
		queue_free()

extends CharacterBody2D
class_name Mario

#var camera: Camera2D
var speed = 250
var gravity = 20
var v_salto = -400
var hspeed

@onready var Animacion = $AnimatedSprite2D
var is_big = false


func _ready():
	#camera = get_node("Camera2D")  # Ajusta la ruta al nodo de tu cámara
	pass
	
func _physics_process(delta):
	_animations()
	_gravity()
	_controls()
	
	move_and_slide()
	
func _gravity():
	velocity.y += gravity

func _controls():
	#correr mas rapido
	if Input.is_action_just_pressed("m_mas_rapido"):
		hspeed = speed * 1.5
	else :
		hspeed = speed
	#movimiento horizontal
	if Input.is_action_pressed("m_derecha"):
		Animacion.flip_h = false
		velocity.x = speed
	elif  Input.is_action_pressed("m_izquierda"):
		Animacion.flip_h = true
		velocity.x = -speed
	else:
		velocity.x = 0
	#salto
	if Input.is_action_just_pressed("m_saltar"):
		velocity.y = v_salto

func _animations():
	if is_big:
		if not is_on_floor():
			Animacion.play("jump_b")
		else:
			if velocity.x != 0:
				Animacion.play("walk_b")
			else:
				Animacion.play("idle_b")
	else:
		if not is_on_floor():
			Animacion.play("jump_s")
		else:
			if velocity.x != 0:
				Animacion.play("walk_s")
			else:
				Animacion.play("idle_s")

func _on_area_2d_area_entered(area):
	print("entra en el area")
	if area.get_parent().is_in_group("hongo"):
		print("hongo detectado")
		is_big = true
		$CollisionShape_s.call_deferred("set_disabled", true)
		$CollisionShape_b.call_deferred("set_disabled", false)
		area.get_parent().call_deferred("queue_free")



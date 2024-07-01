extends CharacterBody2D
class_name Mario

var speed = 250
var gravity = 20
var v_salto = -500
var hspeed
@onready var Animacion = $AnimatedSprite2D
@export var atack: PackedScene
var is_big = false
var is_fire = true

func _ready():
	add_to_group("Mario")

func _physics_process(delta):
	_animations()
	_gravity()
	_controls()
	move_and_slide()

func _gravity():
	velocity.y += gravity

func _controls():
	if Input.is_action_just_pressed("m_mas_rapido"):
		hspeed = speed * 1.5
	else:
		hspeed = speed
	
	if Input.is_action_pressed("m_derecha"):
		Animacion.flip_h = false
		velocity.x = speed
	elif Input.is_action_pressed("m_izquierda"):
		Animacion.flip_h = true
		velocity.x = -speed
	else:
		velocity.x = 0
	
	if Input.is_action_just_pressed("m_saltar"):
		velocity.y = v_salto
	
	if Input.is_action_just_pressed("m_atacar") and is_fire:
		_atack()

func _animations():
	if is_fire:
		_collisions()
		if not is_on_floor():
			Animacion.play("jump_f")
		else:
			if velocity.x != 0:
				Animacion.play("walk_f")
			else:
				Animacion.play("idle_f")
	elif is_big:
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

func _atack():
	var atack_inst = atack.instantiate()
	get_tree().root.call_deferred("add_child", atack_inst)
	atack_inst.global_position = global_position
	atack_inst.set_direccion(not Animacion.flip_h)

func _on_area_2d_area_entered(area):
	print("Area entered: ", area)
	print("Area parent: ", area.get_parent())
	print("Area parent groups: ", area.get_parent().get_groups())
	
	if area.get_parent().is_in_group("hongo"):
		print("hongo detectado")
		is_big = true
		_collisions()
		area.get_parent().call_deferred("queue_free")
	elif area.is_in_group("flor"):
		print("flor detectada")
		is_fire = true
		is_big = true
		_collisions()
		area.call_deferred("queue_free")
	elif area.get_parent().is_in_group("enemigo_1"):
		print("enemigo detectado")
		if area.get_parent().has_method("die"):
			area.get_parent().die()
		else:
			area.get_parent().call_deferred("queue_free")

func _on_area_2d_body_entered(body):
	print("Body entered: ", body)
	print("Body groups: ", body.get_groups())
	
	if body.is_in_group("enemigo_1"):
		print("enemigo detectado (colisión de cuerpo)")
		if body.has_method("die"):
			body.die()
		else:
			body.call_deferred("queue_free")

func _collisions(set_small = false):
	$CollisionShape_s.call_deferred("set_disabled", not set_small)
	$Area2D/CollisionShape_sa.call_deferred("set_disabled", not set_small)
	$CollisionShape_b.call_deferred("set_disabled", set_small)
	$Area2D/CollisionShape_ba.call_deferred("set_disabled", set_small)

func die() -> void:
	set_physics_process(false)  # Detiene el movimiento de Mario
	
	# Desactiva todas las colisiones posibles
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
	
	var animation_name = "dead_s"
	if is_fire:
		animation_name = "dead_f"
	elif is_big:
		animation_name = "dead_b"
	
	Animacion.play(animation_name)  # Reproduce la animación de muerte correspondiente
	await Animacion.animation_finished  # Espera a que termine la animación
	
	# Reinicia el nivel
	restart_level()

func restart_level():
	# Obtiene la ruta de la escena actual
	var current_scene_path = get_tree().current_scene.scene_file_path
	
	# Recarga la escena actual
	get_tree().change_scene_to_file(current_scene_path)

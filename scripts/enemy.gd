extends CharacterBody2D
class_name enemy

const SPEED = 70
const GRAVITY = 980

var direction = -1

@onready var animated_sprite = $AnimatedSprite2D
@onready var floor_check = $FloorCheck
@onready var wall_check = $WallCheck

func _ready():
	floor_check.enabled = true
	wall_check.enabled = true

func _physics_process(delta):
	apply_gravity(delta)
	check_direction()
	move()
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func move():
	velocity.x = SPEED * direction
	animated_sprite.play("walk")
	animated_sprite.flip_h = direction > 0

func check_direction():
	if is_on_wall() or wall_check.is_colliding():
		print("Pared detectada")
		change_direction()
	elif not floor_check.is_colliding() and is_on_floor():
		print("Borde detectado")
		change_direction()

func change_direction():
	print("Cambiando dirección")
	direction *= -1
	wall_check.target_position.x *= -1
	floor_check.position.x *= -1

func die() -> void:
	set_physics_process(false)  # Detiene el movimiento del enemigo
	
	# Desactiva todas las colisiones posibles
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
	
	animated_sprite.play("dead")  # Reproduce la animación de muerte
	await animated_sprite.animation_finished  # Espera a que termine la animación
	queue_free()  # Elimina el enemigo

func _on_area_2d_body_entered(body):
	if body.is_in_group("Mario"):
		print("detecta a mario")
		if body.has_method("die"):
			body.die()

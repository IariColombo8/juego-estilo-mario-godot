extends CharacterBody2D

const  gravity = 50
const hspeed = 50
var direccion = 1

func _physics_process(delta):
	_gravity()
	_move()
	move_and_slide()

func _move():
	if direccion == 1:
		velocity.x = hspeed
	elif  direccion == -1:
		velocity.x = -hspeed

func _gravity():
	if not is_on_floor():
		velocity.y +=gravity

func _on_area_2d_body_entered(body):
	if body.is_in_group("tuboo"):
		print("detecta el tubo")
		direccion = -1

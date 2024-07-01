extends CharacterBody2D

const gravity = 1
const  v_salto = 6
const  speed = 4
var direccion
func _physics_process(delta):
	_gravity()
	velocity.x = speed * direccion
	if move_and_collide(velocity):
		_jump()
	
func _gravity():
	velocity.y +=gravity


func _jump():
	velocity.y = -v_salto
func set_direccion(direccion):
	if direccion:
		self.direccion = 1
	else:
		self.direccion = -1
func _on_timer_timeout():
	pass # Replace with function body.
	


func _on_area_2d_body_entered(body):
	if body.is_in_group("tuboo"):
		call_deferred("queue_free")
	else:
		if body.is_in_group("enemigo_1"):
			body.call_deferred("queue_free")

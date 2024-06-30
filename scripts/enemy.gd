
extends CharacterBody2D
class_name enemy
var hola =1
const EnemyRun = 70
const Gravedad = 98
var Dead =1
var hit = false
func _ready():
	velocity.x = -EnemyRun
	$AnimatedSprite2D.play("walk")

func _physics_process(delta):
	velocity.y += Gravedad * delta
	# Handle jump.
	if is_on_wall():
		if !$AnimatedSprite2D.flip_h:
			velocity.x = EnemyRun
		else: 
			velocity.x = -EnemyRun
		
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
	move_and_slide()


func _on_area_2d_area_entered(area):
	queue_free()

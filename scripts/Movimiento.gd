extends Control
class_name Movimiento
@export var speed: float = 4.0
@export var jump_speed: float = 2.0  # Velocidad inicial del salto
@export var max_speed: float = 1.0

var character: CharacterBody2D

func setup(character2D: CharacterBody2D):
	character = character2D

func move(input_vector: Vector2):
	var velocity = input_vector.normalized() * speed
	var collision = character.move_and_collide(velocity)
	if collision:
		# Handle collision if needed
		pass

#@onready var Player:player = $"player" as player
func saltar():
	character.velocity.y -= jump_speed

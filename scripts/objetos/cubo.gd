extends StaticBody2D

@onready var Animacion = $AnimatedSprite2D
func _on_area_2d_area_entered(area):
	if Animacion.animation != "vacio":
		Animacion.play("vacio")

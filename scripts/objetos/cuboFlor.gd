extends StaticBody2D

@onready var Animacion = $AnimatedSprite2D
@export var prize:PackedScene

func _on_area_2d_area_entered(area):
	if Animacion.animation != "vacio":
		Animacion.play("vacio")
		_otro_objeto()
		
func _otro_objeto():
	var prize_inst = prize.instantiate()
	get_tree().root.call_deferred("add_child", prize_inst)
	prize_inst.global_position = global_position
	

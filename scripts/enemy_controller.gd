extends CharacterBody2D
class_name EnemyController

@export var health = 3

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var is_taking_damage = false

func take_damage():
	if not is_taking_damage:
		is_taking_damage = true
		animated_sprite_2d.play("take_damage")


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_taking_damage:
		health -= 1
		if health <= 0:
			queue_free()
			return
		else:
			animated_sprite_2d.play("idle")	
		is_taking_damage = false
	

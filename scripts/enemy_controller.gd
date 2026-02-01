extends CharacterBody2D
class_name EnemyController

signal died(pos: Vector2)

@export var max_health = 10
@onready var health = max_health
@onready var status_manager: StatusManager = $StatusManager
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_taking_damage = false

func take_hit(attack_data: AttackData):
	# Apply Raw Damage
	apply_raw_damage(attack_data.damage)
	
	# Apply Status Effects (Burn, Slow, etc)
	for effect in attack_data.effects:
		status_manager.add_effect(effect)
	
	# Visual Feedback
	if not is_taking_damage:
		is_taking_damage = true
		animated_sprite_2d.play("take_damage")

func apply_raw_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	died.emit(global_position)
	queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	if is_taking_damage:
		is_taking_damage = false
		if health > 0:
			animated_sprite_2d.play("idle")

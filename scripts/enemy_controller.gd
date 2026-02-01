extends CharacterBody2D
class_name EnemyController

# Signals for the Brain to listen to
signal died(pos: Vector2)
signal hit_received(attack_data: AttackData)

@export var max_health = 10
@export var speed: float = 30.0
@export var direction_multiplier: Vector2 = Vector2(1, 0.5) 

@onready var health = max_health
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# We expose the StatusManager so the Brain or AttackData can access it
@onready var status_manager = $StatusManager if has_node("StatusManager") else null

func _physics_process(_delta: float) -> void:
	# PURE PHYSICS: The brain sets the velocity, we just apply it.
	move_and_slide()

func take_hit(attack_data: AttackData):
	# 1. DATA: Apply the raw numbers
	health -= attack_data.damage
	
	if status_manager:
		for effect in attack_data.effects:
			status_manager.add_effect(effect)
	
	# 2. NOTIFICATION: Tell the Brain we got hit (so it can play animations)
	hit_received.emit(attack_data)
	
	# 3. STATE: Check for death
	if health <= 0:
		die()

func die():
	died.emit(global_position)
	queue_free()

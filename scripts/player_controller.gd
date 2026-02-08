extends CharacterBody2D
class_name Player

enum PlayerState {ATTACKING, IDLE}

@export var speed: float = 40.0
@export var direction_multiplier: Vector2 = Vector2(1, 0.5)
@export var base_attack: AttackData


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea



var is_flipped = false
var state: PlayerState = PlayerState.IDLE
var attack_area_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	attack_area_offset = attack_area.position

func _physics_process(delta: float) -> void:
	if state == PlayerState.ATTACKING:
		# just starts monitoring hitbox after the first frame
		attack_area.monitoring = true 
		return
	
	if Input.is_action_just_pressed("ui_accept"):
		state = PlayerState.ATTACKING
		velocity = Vector2.ZERO
		animated_sprite_2d.play("attack_1")
		AudioManager.play_punch()
		move_and_slide()
		return
		
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction == Vector2.ZERO:
		velocity = direction * 0
		animated_sprite_2d.play("idle")
	else: 
		velocity = direction.normalized() * direction_multiplier * speed
		animated_sprite_2d.play("walk")
		if Input.is_action_pressed("ui_left"):
			is_flipped = true
		elif Input.is_action_pressed("ui_right"):
			is_flipped = false
			
		animated_sprite_2d.flip_h = is_flipped
		attack_area.position = attack_area_offset
		if is_flipped:
			attack_area.position.x = -attack_area.position.x
		

	move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if state == PlayerState.ATTACKING:
		state = PlayerState.IDLE
		attack_area.monitoring = false


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_hit"):
		#body.take_damage()
		
		var current_attack = base_attack.duplicate()
		# Example scaling: current_attack.damage += player_level
		
		body.take_hit(current_attack)


var audioPlayer := AudioStreamPlayer.new()

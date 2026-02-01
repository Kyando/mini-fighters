extends Node
class_name FollowPlayerComponent

enum State { CHASE, ATTACK, HURT }

@export var stop_distance: float = 30.0
@export var attack_range: float = 35.0
@export var attack_cooldown: float = 1.5
# New: How hard they push away from friends
@export var separation_force: float = 2.0 

@onready var parent: EnemyController = get_parent()
# FIX: Get the node directly. We cannot use 'parent.animated_sprite_2d' 
# because the parent's _ready() hasn't run yet when this runs.
@onready var anim: AnimatedSprite2D = parent.get_node("AnimatedSprite2D")
# Optional: Look for a specific area for soft collisions
@onready var separation_area: Area2D = parent.get_node_or_null("SeparationArea")

var target: Node2D = null
var current_state: State = State.CHASE
var attack_timer: float = 0.0

func _ready() -> void:
	# 1. Find Target
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0]
	
	# 2. Listen to the Container (Parent)
	parent.hit_received.connect(_on_take_hit)
	
	# Safety check
	if anim:
		anim.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	attack_timer -= delta
	
	match current_state:
		State.CHASE:
			_process_chase()
		State.ATTACK:
			_process_attack()
		State.HURT:
			_process_hurt()

# --- STATE LOGIC ---

func _process_chase():
	if not target: 
		parent.velocity = Vector2.ZERO
		return
		
	var dist = parent.global_position.distance_to(target.global_position)
	
	# Transition: Can we Attack?
	if dist <= attack_range and attack_timer <= 0:
		_enter_attack_state()
		return
		
	# Logic: Move towards player
	if dist > stop_distance:
		var dir = parent.global_position.direction_to(target.global_position)
		var base_velocity = dir.normalized() * parent.speed * parent.direction_multiplier
		
		# Combine Chase Velocity with Separation Force
		parent.velocity = base_velocity + _get_separation_vector()
		
		# Visuals
		if anim:
			anim.play("walk")
			if parent.velocity.x != 0:
				anim.flip_h = parent.velocity.x < 0
	else:
		parent.velocity = Vector2.ZERO
		if anim:
			anim.play("idle")

func _process_attack():
	# Logic: Stand still while swinging
	parent.velocity = Vector2.ZERO

func _process_hurt():
	# Logic: Stunned (knockback could be added here)
	parent.velocity = Vector2.ZERO

# --- HELPERS ---

func _get_separation_vector() -> Vector2:
	var separation = Vector2.ZERO
	if not separation_area:
		return separation
		
	var areas = separation_area.get_overlapping_areas()
	if areas.size() == 0:
		return separation
		
	for area in areas:
		# Calculate a vector pointing AWAY from the neighbor
		var push_dir = area.global_position.direction_to(parent.global_position)
		separation += push_dir.normalized()
	
	# Average the force so it doesn't shoot them off screen
	return separation * separation_force

# --- TRANSITIONS ---

func _enter_attack_state():
	current_state = State.ATTACK
	attack_timer = attack_cooldown
	if anim:
		anim.play("attack")
	if parent.has_node("AttackArea"):
		parent.get_node("AttackArea").monitoring = true

func _on_take_hit(_data):
	# Force transition to HURT state, interrupting anything else
	current_state = State.HURT
	if anim:
		anim.play("take_damage")
	# Disable hitbox if we were interrupted mid-swing
	if parent.has_node("AttackArea"):
		parent.get_node("AttackArea").monitoring = false

func _on_animation_finished():
	# When animation ends, decide where to go next
	match current_state:
		State.ATTACK:
			# Attack done -> Back to Chase
			if parent.has_node("AttackArea"):
				parent.get_node("AttackArea").monitoring = false
			current_state = State.CHASE
			
		State.HURT:
			# Pain done -> Back to Chase
			current_state = State.CHASE

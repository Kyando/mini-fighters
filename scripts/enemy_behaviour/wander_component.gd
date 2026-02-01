extends Node
class_name WanderComponent

@export var change_direction_time: float = 2.0
@onready var parent: EnemyController = get_parent()

var timer: float = 0.0

func _ready() -> void:
	_pick_new_direction()

func _physics_process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		_pick_new_direction()

func _pick_new_direction() -> void:
	# Pick a random direction or idle (Vector2.ZERO)
	var angles = [0, 45, 90, 135, 180, 225, 270, 315]
	var random_angle = deg_to_rad(angles[randi() % angles.size()])
	
	if randf() > 0.3: # 70% chance to move, 30% to idle
		parent.movement_direction = Vector2.RIGHT.rotated(random_angle)
	else:
		parent.movement_direction = Vector2.ZERO
		
	timer = change_direction_time + randf_range(-0.5, 0.5)

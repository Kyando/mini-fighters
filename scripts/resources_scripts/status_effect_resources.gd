extends Resource
class_name StatusEffect

@export var effect_name: String = "Effect"
@export var duration: float = 3.0
@export var tick_interval: float = 1.0
@export var damage_per_tick: int = 1

# Called when the effect is first applied
func apply(target: Node2D):
	target.modulate = Color.RED

# Called every 'tick_interval'
func tick(target: Node2D):
	if target.has_method("apply_raw_damage"):
		target.apply_raw_damage(damage_per_tick)

# Called when the duration expires
func remove(target: Node2D):
	target.modulate = Color.WHITE

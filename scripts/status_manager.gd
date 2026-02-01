extends Node
class_name StatusManager

# Stores active effects to allow refreshing them.
# Format: { "EffectName": { "tick_timer": Timer, "duration_timer": Timer, "resource": StatusEffect } }
var active_effects = {} 

func add_effect(effect: StatusEffect):
	# 1. REFRESH: If we already have this effect, just reset the duration timer.
	if active_effects.has(effect.effect_name):
		var data = active_effects[effect.effect_name]
		# The .start() function resets the timer to the new duration
		data["duration_timer"].start(effect.duration) 
		return

	# 2. NEW: Apply initial visual/logic
	effect.apply(get_parent())
	
	# Create Tick Timer (handles damage interval)
	var tick_timer = Timer.new()
	tick_timer.wait_time = effect.tick_interval
	tick_timer.autostart = true
	tick_timer.timeout.connect(func(): effect.tick(get_parent()))
	add_child(tick_timer)
	
	# Create Duration Timer (handles when it ends)
	var duration_timer = Timer.new()
	duration_timer.wait_time = effect.duration
	duration_timer.one_shot = true
	duration_timer.autostart = true
	# Connect using a bound function so we know WHICH effect to remove
	duration_timer.timeout.connect(_on_duration_complete.bind(effect.effect_name))
	add_child(duration_timer)
	
	# Store references so we can access them later
	active_effects[effect.effect_name] = {
		"tick_timer": tick_timer,
		"duration_timer": duration_timer,
		"resource": effect
	}

func _on_duration_complete(effect_name: String):
	if active_effects.has(effect_name):
		var data = active_effects[effect_name]
		var effect = data["resource"]
		
		# 1. Revert visual changes
		effect.remove(get_parent())
		
		# 2. Cleanup Timers
		data["tick_timer"].queue_free()
		data["duration_timer"].queue_free()
		
		# 3. Remove from memory
		active_effects.erase(effect_name)

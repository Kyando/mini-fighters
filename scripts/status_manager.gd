extends Node
class_name StatusManager

var active_effects = {} # { "EffectName": Timer }

func add_effect(effect: StatusEffect):
	if active_effects.has(effect.effect_name):
		active_effects[effect.effect_name].time_left = effect.duration
		return

	# Create a timer for the effect
	var timer = Timer.new()
	timer.wait_time = effect.tick_interval
	timer.autostart = true
	add_child(timer)
	
	active_effects[effect.effect_name] = timer
	effect.apply(get_parent())
	
	timer.timeout.connect(func(): effect.tick(get_parent()))
	
	# Cleanup after duration
	await get_tree().create_timer(effect.duration).timeout
	effect.remove(get_parent())
	active_effects.erase(effect.effect_name)
	timer.queue_free()

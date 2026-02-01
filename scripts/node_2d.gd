extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func open_upgrade_screen():
	UIManager.current_screen.visible = true
	UIManager.play(true)
	
func close_upgrade_screen():
	UIManager.current_screen.visible = false
	UIManager.play(false)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_menu") and !UIManager.current_screen.visible:
		open_upgrade_screen()
	elif Input.is_action_just_pressed("open_menu") and UIManager.current_screen.visible:
		close_upgrade_screen()

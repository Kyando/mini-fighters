extends Control

func _ready():
	UIManager.register_screen(self)
	UIManager.upgrade_selected.connect(_on_upgrade_selected)
	visible = false

func _on_upgrade_selected(upgrade):
	close()
	
func close():
	visible = false

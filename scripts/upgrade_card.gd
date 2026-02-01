extends Button
class_name UpgradeCard

var upgrade

func setup(u):
	upgrade = u
	
func _ready():
	print("botao ficou ready")
	mouse_entered.connect(_on_hover)
	pressed.connect(_on_pressed)
	
func _on_hover():
	print("HOVER PRA CARALHOS==")
	UIManager.set_hover(self)
	
func _on_pressed():
	print("SELECIONADO PRA CARALHO")
	UIManager.select(self)

func _process(_delta):
	if UIManager.current_hovered_card == self:
		scale = Vector2.ONE * 1.05
	else:
		scale = Vector2.ONE

extends Button
class_name UpgradeCard

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect

@export var data: CardData:
	set(new_value):
		data = new_value
		if is_node_ready():
			update_visual()

var upgrade

func _ready():
	update_visual()
	
	mouse_entered.connect(_on_hover)
	pressed.connect(_on_pressed)

func update_visual():
	if data and texture_rect:
		texture_rect.texture = data.image
func _on_hover():
	UIManager.set_hover(self)

func _on_pressed():
	UIManager.select(self)

func _process(_delta):
	if UIManager.current_hovered_card == self:
		scale = lerp(scale, Vector2.ONE * 1.05, 0.15)
	else:
		scale = lerp(scale, Vector2.ONE, 0.15)

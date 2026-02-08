extends Control

@onready var container: HBoxContainer = $HBoxContainer
@export var card_list: Array[CardData]

func _ready():
	generate_cards()
	UIManager.register_screen(self)
	UIManager.upgrade_selected.connect(_on_upgrade_selected)
	visible = false

func _on_upgrade_selected(upgrade):
	close()
	
func close():
	visible = false

func generate_cards():
	var available = card_list.duplicate()
	available.shuffle()

	var scene_cards = container.get_children()
	
	for i in range(scene_cards.size()):
		if i < available.size():
			scene_cards[i].data = available[i]
		else:
			scene_cards[i].visible = false

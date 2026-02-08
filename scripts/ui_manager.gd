extends Node

signal upgrade_hovered(upgrade)
signal upgrade_selected(upgrade)
signal ui_opened
signal ui_closed

var current_hovered_card = null
var current_screen = null

var selected_index := 0
var cards := []
var round = 1
var level_progress = 0
var level = 1

const LEVEL_MAX := 100

func set_round(round):
	round = round
	
func set_level_progress(progress):
	level_progress += progress

	if level_progress >= LEVEL_MAX:
		show_upgrade_screen()
		level_progress = 0
		level_up()

func show_upgrade_screen():
	play(true)
	current_screen.visible = true

func level_up():
	level += 1

func register_screen(screen):
	current_screen = screen
	
func set_hover(card):
	if current_hovered_card == card:
		return
	current_hovered_card = card
	emit_signal("upgrade_hovered", card.upgrade)

func select(card):
	emit_signal("upgrade_selected", card.upgrade)
	

func register_cards(list):
	cards = list

func move_selection(dir):
	selected_index = wrapi(selected_index + dir, 0, cards.size())
	set_hover(cards[selected_index])

func play_open_screen():
	emit_signal("ui_opened")

func play_close_screen():
	emit_signal("ui_closed")
	
	
func play(isOpen):
	if isOpen:
		play_open_screen()
	else:
		play_close_screen()
	

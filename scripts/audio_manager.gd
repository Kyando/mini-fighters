extends Node

@export var ui_hover: AudioStream
@export var ui_select: AudioStream
@export var ui_open: AudioStream
@export var ui_close: AudioStream

var player := AudioStreamPlayer.new()
	
func play_ui(sound: AudioStream):
	player.pitch_scale = randf_range(0.95, 1.05)

	if sound == null:
		return
	player.stream = sound
	player.play()
	
func _ready():
	add_child(player)

	UIManager.upgrade_hovered.connect(func(upgrade):
		play_ui(ui_hover)
	)

	UIManager.upgrade_selected.connect(func(upgrade):
		play_ui(ui_select)
	)

	UIManager.ui_opened.connect(func():
		play_ui(ui_open)
	)

	UIManager.ui_closed.connect(func():
		play_ui(ui_close)
	)

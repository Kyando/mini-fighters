extends Node

@export var ui_hover: AudioStream
@export var ui_select: AudioStream
@export var ui_open: AudioStream
@export var ui_close: AudioStream
@export var player_punch: AudioStream
@export var player_hit: AudioStream

var player := AudioStreamPlayer.new()

func play_hit():
	var number = randi_range(1, 4)
	var file_path = "res://assets/ggj/music/sfx/SFX PUNCH HIT " + str(number) + ".mp3"
	print("playing " + file_path)
	var sfx = load(file_path)
	
	if sfx == null:
		print("Erro ao carregar: " + file_path)
		return

	var p = AudioStreamPlayer.new()
	get_tree().root.add_child(p)
	
	p.stream = sfx
	p.pitch_scale = randf_range(0.9, 1.1)
	p.play()
	 
	p.finished.connect(func(): p.queue_free())
	
	
func play_punch():
	var number = randi_range(1, 4)
	var file_path = "res://assets/ggj/music/sfx/SFX PUNCH " + str(number) + ".mp3"
	print("playing " + file_path)
	var sfx = load(file_path)
	
	if sfx == null:
		print("Erro ao carregar: " + file_path)
		return

	var p = AudioStreamPlayer.new()
	get_tree().root.add_child(p)
	
	p.stream = sfx
	p.pitch_scale = randf_range(0.9, 1.1)
	p.play()
	 
	p.finished.connect(func(): p.queue_free())
	
func play_ui(sound: AudioStream):
	player.pitch_scale = randf_range(0.95, 1.05)

	if sound == null:
		return
	player.stream = sound
	player.play()
	
	
func play_ui_audio():
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
	
	
func _ready():
	add_child(player)
	play_ui_audio()

extends Control

@onready var intro = $main_theme_intro
@onready var loop = $main_theme_loop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intro.finished.connect(_on_intro_finished)
	intro.play()

func _on_intro_finished():
	loop.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_jam_test_scene.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

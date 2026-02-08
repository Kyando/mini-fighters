extends Control

@onready var level_bar: ProgressBar = $ProgressBar
@onready var round: Label = $LevelLabel
@onready var level_label: Label = $LevelLabel

func _process(_delta: float) -> void:
	round.text = "Round" + str(UIManager.round)
	level_bar.value = UIManager.level_progress
	level_label.text = "Level" + str(UIManager.level)

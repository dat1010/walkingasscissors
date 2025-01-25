extends Label

@onready var label: Label = $"."


func end_game_high_score():
	label.text = "You DIED!!!!"


func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

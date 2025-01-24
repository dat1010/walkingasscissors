extends Label

@onready var label: Label = $"."


func end_game_high_score():
	label.text = "You DIED!!!!"

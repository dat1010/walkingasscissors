extends Control

var visible_characters = 0
 
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _process(delta: float) -> void:
	if visible_characters != rich_text_label.visible_characters:
		visible_characters = rich_text_label.visible_characters
		audio_stream_player_2d.play()
	


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

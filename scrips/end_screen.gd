extends Control

@onready var http_request: HTTPRequest = $HTTPRequest
var url = "https://davidtannerjr.com/api/high_scores"
@onready var rich_text_label: RichTextLabel = $ScrollContainer/VBoxContainer/RichTextLabel
@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var enter_high_score: LineEdit = $EnterHighScore
@onready var submit: Button = $EnterHighScore/Submit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	http_request.request(url)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 201:
		clear_all_childer()
		http_request.request(url)
	elif response_code == 200:
		update_high_score_results(body)

func _on_submit_pressed() -> void:
	var user_initials = enter_high_score.text
	var score = global.current_score
	var data := {"high_score":{"user_initials":user_initials,"score":score}}
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	http_request.request(url, headers, HTTPClient.METHOD_POST, json)
	submit.visible = false
	global.current_score = 0
	
func update_high_score_results(body):
	var data = JSON.parse_string(body.get_string_from_utf8())
	var response = body.get_string_from_utf8()
	
	for user_data in data.data:
		var label = RichTextLabel.new()
		label.fit_content = true
		var user_initials = user_data.user_initials
		var user_score = user_data.score
		label.text = user_initials + " " + str(user_score)
		v_box_container.add_child(label)
		
func clear_all_childer():
	var count = v_box_container.get_child_count()
	for child in range(count):
		var children = v_box_container.get_child(child)
		children.queue_free()

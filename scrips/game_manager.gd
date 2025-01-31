extends Node
# todo create global variable for enemy, player and rock kill count

@export var enemy_scene : PackedScene
@export var paper_scene : PackedScene
@export var player_node_path: NodePath
@export var spawn_min: Vector2 = Vector2(-150, -150)
@export var spawn_max: Vector2 = Vector2(150, 150)

var current_round: int = 1
var enemies_alive: int = 0
var game_active: bool = true

func _ready() -> void:
	var player = get_node(player_node_path)
	player.connect("player_died", Callable(self, "_on_player_died"))
	start_round(current_round)

func start_round(round_number: int) -> void:
	enemies_alive = 0 
	
	for i in range(round_number):
		global.current_score = round_number
		var new_enemy = enemy_scene.instantiate()
		var new_paper = paper_scene.instantiate()
		add_child(new_enemy)
		add_child(new_paper)
		
		var random_pos = Vector2(
			randf_range(spawn_min.x, spawn_max.x),
			randf_range(spawn_min.y, spawn_max.y)
		)
		new_enemy.position = random_pos
		
		var random_pos_paper = Vector2(
			randf_range(spawn_min.x-10, spawn_max.x+10),
			randf_range(spawn_min.y-10, spawn_max.y+10)
		)
		new_paper.position = random_pos_paper
		
		new_enemy.connect("enemy_died", Callable(self, "_on_enemy_died"))
		
		enemies_alive += 1
	
	print("Starting round %d with %d enemies" % [round_number, enemies_alive])


func _on_enemy_died() -> void:
	enemies_alive -= 1
	print("Enemy died! Remaining: ", enemies_alive)

	if enemies_alive <= 0 and game_active:
		current_round += 1
		start_round(current_round)

func _on_player_died() -> void:
	game_active = false
	print("Game Over! You survived up to round %d" % current_round)

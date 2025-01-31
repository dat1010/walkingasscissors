extends CharacterBody2D


const SPEED = 100
const BASE_HEALTH = 100
var current_direction = "none"
signal player_died
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var deal_attack_timer: Timer = $DealAttackTimer
@onready var health_bar: ProgressBar = $HealthBar
@export var end_screen_scene:PackedScene

var enemy_in_attack_range = false
var enemy_in_attack_cooldown = true
var health = 100
var is_player_alive = true
var attack_in_progress = false
var paper_in_attack_range = false

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	paper_attack()
	update_health_bar()
	if health <= 0:
		is_player_alive = false
		health = 0
		print("Player has been killed")
		emit_signal("player_died")
		get_tree().change_scene_to_packed(end_screen_scene)
		#self.queue_free() 
		#TODO add end screen
		
		
var held_directions = []
var direction = "right"


func player_movement(delta):
	var direction = Vector2.ZERO
	
	# Collect input:
	if Input.is_action_pressed("ui_up"):
		current_direction = "up"
		play_animation(1)
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		current_direction = "down"
		play_animation(1)
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		current_direction = "left"
		play_animation(1)
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		current_direction = "right"
		play_animation(1)
		direction.x += 1
	
	# Normalize to ensure consistent speed in all directions (including diagonals).
	if direction != Vector2.ZERO:
		direction = direction.normalized() * SPEED
	
	# Assign to the CharacterBody2D's built-in velocity and move:
	velocity = direction
	move_and_slide()
	

func play_animation(movement):
	var direction = current_direction
	
	# Decide whether to flip horizontally based on direction
	if direction == "right":
		animated_sprite_2d.flip_h = false
	elif direction == "left":
		animated_sprite_2d.flip_h = true
	elif direction == "down":
		animated_sprite_2d.flip_h = false
	elif direction == "up":
		animated_sprite_2d.flip_h = false

	if movement == 1:
		if attack_in_progress:
			animated_sprite_2d.play("attack")
		else:
			animated_sprite_2d.play("default")
	else:
		if attack_in_progress:
			animated_sprite_2d.play("attack")
		else:
			animated_sprite_2d.play("default")

				
func attack():
	var direction = current_direction
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_in_progress = true
		if direction == "right":
			#animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("attack")
			deal_attack_timer.start()
		if direction == "left":
			#animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("attack")
			deal_attack_timer.start()
		if direction == "down":
			animated_sprite_2d.play("attack")
			deal_attack_timer.start()
		if direction == "up":
			animated_sprite_2d.play("attack")
			deal_attack_timer.start()
			
			
func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true
	if body.has_method("paper"):
		paper_in_attack_range = true
		
func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false
	if body.has_method("paper"):
		paper_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range and enemy_in_attack_cooldown:
		health -= 20
		enemy_in_attack_cooldown = false
		attack_cooldown.start()
		print(health)

func paper_attack():
	if paper_in_attack_range and Input.is_action_just_pressed("attack"):
		health = BASE_HEALTH

func _on_attack_cooldown_timeout() -> void:
	enemy_in_attack_cooldown = true
	



func _on_deal_attack_timer_timeout() -> void:
	deal_attack_timer.stop()
	global.player_current_attack = false
	attack_in_progress = false
	
func update_health_bar():
	health_bar.value = health
	if health >= BASE_HEALTH:
		health_bar.visible = false
	else:
		health_bar.visible = true

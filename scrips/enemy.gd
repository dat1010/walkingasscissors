extends CharacterBody2D

var SPEED = 50
var player_chase = false
var player = null
var health = 100
var is_player_in_attack_zone = false
var can_take_damage = true
signal enemy_died

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var take_damage_cooldown: Timer = $TakeDamageCooldown
@onready var health_bar: ProgressBar = $HealthBar

func _physics_process(delta):
	deal_with_damage()
	update_healh()
	if player_chase:
		position += (player.position - position)/SPEED
		animated_sprite_2d.play("roll")
		
		if (player.position.x - position.x) < 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.play("idle")
		

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func enemy():
	pass
	
func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		is_player_in_attack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		is_player_in_attack_zone = false

func deal_with_damage():
	if is_player_in_attack_zone and global.player_current_attack:
		if can_take_damage:
			health -= 50
			take_damage_cooldown.start()
			can_take_damage = false
			if health <= 0:
				#animated_sprite_2d.play("death")
				#await animated_sprite_2d.animation_finished TODO this breaks the death of the rock. somehow the rock keeps going and wont die with this wait
				emit_signal("enemy_died")
				self.queue_free()
	
func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
	
func update_healh():
	health_bar.value = health
	if health >= 100:
		health_bar.visible = false
	else:
		health_bar.visible = true

	

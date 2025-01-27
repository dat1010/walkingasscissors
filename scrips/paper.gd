extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_player_in_attack_zone = false
var is_enemy_in_attack_zone = false

func _physics_process(delta):
	deal_with_damage()
	
func paper():
	pass
	
func deal_with_damage():
	if is_player_in_attack_zone and global.player_current_attack:
		kill_paper()

func _on_paper_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		is_player_in_attack_zone = true
	if body.has_method("enemy"):
		kill_paper()

func _on_paper_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		is_player_in_attack_zone = false
	if body.has_method("enemy"):
		is_enemy_in_attack_zone = false

func kill_paper():
	is_enemy_in_attack_zone = true
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	self.queue_free()

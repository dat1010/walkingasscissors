extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_player_in_attack_zone = false

func _physics_process(delta):
	deal_with_damage()

func deal_with_damage():
	if is_player_in_attack_zone and global.player_current_attack:
		animated_sprite_2d.play("death")
		await animated_sprite_2d.animation_finished
		self.queue_free()
	
func _on_paper_hitbox_area_entered(body):
	print(animated_sprite_2d)
	is_player_in_attack_zone = true

func paper():
	pass

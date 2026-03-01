
extends CharacterBody2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var max_health = 2
var health_min = 0
const speed = 100
@export var player: CharacterBody2D
var health: int = 2
var damage: int = 1
var can_damage: bool = true
var damage_cooldown: float = 1.0
var flash_tween: Tween
#@onready var navigation_agent_2d:= $NavigationAgent2D as NavigationAgent2D

func _physics_process(delta: float) -> void:
	#var dir = to_local(navigation_agent_2d.get_next_path_position()).normalized()
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * speed 
	animated_sprite_2d.play("Backcan")
	move_and_slide()
	
	if can_damage and global_position.distance_to(player.global_position) < 30:
		player.take_damage(damage)
		can_damage = false
		await get_tree().create_timer(damage_cooldown).timeout
		can_damage = true

func take_damage(amount: int) -> void:
	_flash_red()
	health -= amount
	if health <= 0:
		queue_free()

func _flash_red() -> void:
	if flash_tween:
		flash_tween.kill()
	flash_tween = create_tween()
	flash_tween.tween_property(self, "modulate", Color.RED, 0.0)
	flash_tween.tween_property(self, "modulate", Color.WHITE, 0.2)

func makepath() -> void:
	if player != null:
		navigation_agent_2d.target_position = player.global_position
	
	
func _on_timer_timeout() -> void:
	makepath()

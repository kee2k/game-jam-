extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $hitbox
@onready var hp_bar = $hp

@export var SPEED := 300.0
@export var acceleration := 10.0

var health: int = 20: set = _set_health
var max_health: int = 20
var health_min = 0
var flash_tween: Tween

func _set_health(value: int):
	health = value
	if hp_bar:
		hp_bar.value = health
	if health <= 0:
		queue_free()
	
func _ready():
	max_health = 20
	health = 20
	if hp_bar:
		hp_bar.max_value = max_health
		hp_bar.value = health
	
func take_damage(amount: int):
	print("Player hit! Damage: ", amount, " Health: ", health - amount)
	_flash_red()
	self.health -= amount

func _flash_red() -> void:
	if flash_tween:
		flash_tween.kill()
	flash_tween = create_tween()
	flash_tween.tween_property(self, "modulate", Color.RED, 0.0)
	flash_tween.tween_property(self, "modulate", Color.WHITE, 0.2)

var animation_direction: String = "down"

var animation_state: String = ""

func update_sprite_direction(input: Vector2) -> void:
	match input:
		Vector2.DOWN:
			animation_direction = "down"
		Vector2.UP:
			animation_direction = "up"
		Vector2.RIGHT:
			animation_direction = "right"
		Vector2.LEFT:
			animation_direction = "left"

	

func update_sprite() -> void:
	if velocity.length() > 0:
		animation_state = "move_"
	else:
		animation_state = "idle_"


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	
	update_sprite_direction(direction)
	update_sprite()
	
	animated_sprite_2d.play(animation_state+animation_direction)
	
	velocity.x = move_toward(velocity.x, direction.x*SPEED, acceleration)
	velocity.y = move_toward(velocity.y, direction.y*SPEED, acceleration)
	
	move_and_collide(velocity*delta)

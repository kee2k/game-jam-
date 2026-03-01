extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED := 300.0
@export var acceleration := 10.0

var health: int: set = _set_health
func _set_health(value: int):
	max_health = value
	$hp.max_value = value
var max_health: int: set = _set_max_health

func _set_max_health(value: int):
	max_health = value
	$hp.max_value = value
	
func _ready():
	max_health = 100
	
func take_damage(amount: int):
	health -= amount

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

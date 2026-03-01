extends Node2D

const bullet_scene = preload("res://bullet.tscn")

const IS_Player = true

@onready var rotation_offset: Node2D = $RotationOffset
@onready var shadow: Sprite2D = $RotationOffset/Sprite2D/shadow
@onready var marker_2d: Marker2D = $RotationOffset/Sprite2D/Marker2D

var time_between_shot: float = 0.25
var can_shoot: bool = true

func  _ready() -> void:
	$ShootTimer.wait_time = time_between_shot
	
	
func _physics_process(delta: float) -> void:
	rotation_offset.rotation = lerp_angle(rotation_offset.rotation, (get_global_mouse_position() - global_position).angle(), 4*delta)
	shadow.position = Vector2(-2, 2).rotated(-rotation_offset.rotation)
	
	
	if Input.is_action_just_pressed("shoot") and can_shoot:
		_shoot()
		can_shoot = false
		$ShootTimer.start()
		
func _shoot():
	var new_bullet = bullet_scene.instantiate()
	get_parent().add_child(new_bullet)
	new_bullet.global_transform = marker_2d.global_transform
	new_bullet.speed = 200

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

extends CharacterBody2D

const platform = preload("res://Platform.tscn")
const sticky_platform = preload("res://stickycrystal.tscn")
@onready var chisel_rot =$ChiselRotation
@onready var chisel_pos =$ChiselRotation/ChiselPosition
const SPEED = 450.0
const JUMP_VELOCITY = -900.0

var active_tween: Tween = null
var hit_left = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		hit_left = direction > 0.0
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	chisel_rot.rotation_degrees = lerp(chisel_rot.rotation_degrees, 135.0 if hit_left else 225.0, 5 *delta)
	
	if Input.is_action_just_pressed("make_input"):
		var new_plat = platform.instantiate()
		get_tree().root.add_child(new_plat)
		new_plat.global_position = global_position
		new_plat.position.y += 140
	if Input.is_action_just_pressed("make_sticky"):
		var new_plat = sticky_platform.instantiate()
		get_tree().root.add_child(new_plat)
		new_plat.global_position = global_position
		new_plat.position.y += 140
		
	if Input.is_action_just_pressed("hit") and $Area2D.has_overlapping_bodies():
		$Area2D.get_overlapping_bodies()[0].apply_central_impulse(Vector2(1000 if hit_left else -1000, 20))
		active_tween = get_tree().create_tween()
		active_tween.tween_property(chisel_pos, "position:y", -100, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		active_tween.tween_property(chisel_pos, "position:y", 0, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
		
		
	move_and_slide()

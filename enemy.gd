extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("Player")

const SPEED = 300.0
const JUMP_VELOCITY = -700.0

var move_dir = 1.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = JUMP_VELOCITY
	
		if player:
			move_dir = -1.0 if player.position < position else 1.0
			velocity.x = move_dir * 200.0
		
	
	$Sprite2D.rotation += move_dir * delta
	

	move_and_slide()

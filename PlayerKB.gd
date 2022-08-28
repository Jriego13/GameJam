extends KinematicBody

export var speed := 7.0
export var jump_strength := 20.0
export var gravity := 50.0

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN

onready var _spring_arm: SpringArm = $SpringArm
onready var _model: Spatial = $character_duck
onready var animTree := $AnimationTree
onready var stateMachine = animTree["parameters/playback"]

func _ready():
	stateMachine.travel("Idle")

func _physics_process(delta: float) -> void:
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	move_direction = move_direction.rotated(Vector3.UP , _spring_arm.rotation.y).normalized()
	
	_velocity.x = move_direction.x * speed
	_velocity.z = move_direction.z * speed
	_velocity.y -= gravity * delta
	
	if _velocity.x != 0.0:
		stateMachine.travel("Run")
	
	var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
	if is_jumping:
		stateMachine.travel("Jump")
		_velocity.y = jump_strength
		_snap_vector = Vector3.ZERO
		
	elif just_landed:
		_snap_vector = Vector3.DOWN
	_velocity = move_and_slide_with_snap(_velocity , _snap_vector , Vector3.UP , true)
	
	if _velocity.length() > 0.2:
		var look_direction = Vector2(_velocity.z , _velocity.x)
		_model.rotation.y = look_direction.angle()
	
func _process(_delta: float) -> void:
	_spring_arm.translation = translation
	
func die():
	print("you win today satan")
	queue_free()

 extends AnimationTree

var playback : AnimationNodeStateMachinePlayback
onready var animPlayer = get_node("../character_duck/KayKit_AnimatedCharacter_v12/AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var animations = ["Run" , "Idle" ]
	for animation in animations:
		animation = animPlayer.get_animation(animation)
		animation.loop = true
	playback = get("parameters/playback")
	active = true


	
	
	
		

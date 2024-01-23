extends Node

@export var healthLabel : Label
@export var eggSprite : AnimatedSprite2D
@export var armorLabel : Label
@onready var animationPlayer : AnimationPlayer = $UI_AnimationPlayer

func _ready():
	animationPlayer.play("EggGrow")
# Note: egg red hurt animation is in hurt animation on player
func _on_health_component_health_set():
	# Play fry egg animation
	eggSprite.play()

func _on_health_component_armor_changed(old_armor, new_armor):
	# Update armor label text
	armorLabel.text = str(new_armor)
	if(new_armor <= 0):
		animationPlayer.play("EggGrow")
	elif((new_armor > 0) and (old_armor <= 0)):
		animationPlayer.play("EggShrink")

func _on_health_component_health_changed(_old_health, new_health):
	healthLabel.text = str(new_health)

class_name TempFX
extends Node2D

enum Effects {DODGE, SMEAR, SLASH}

var effect: Effects
var effect_data: int
var direction: int

func _ready() -> void:
	match effect:
		Effects.DODGE:
			$FreeTimer.start(1)
			var ghost_effect: GPUParticles2D = $Ghost
			var texture: Texture2D = (
					preload("res://assets/3knight-dash-mirrored.png") if direction < 0
					else preload("res://assets/3knight-dash.png")
			)
			ghost_effect.texture = texture
			ghost_effect.emitting = true

		Effects.SMEAR:
			$AnimationPlayer.play("smear" + str(effect_data))

		Effects.SLASH:
			$Slash.flip_h = effect_data
			$AnimationPlayer.play("slash")


func _on_free_timer_timeout() -> void:
	queue_free()

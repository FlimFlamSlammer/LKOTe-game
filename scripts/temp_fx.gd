class_name TempFX
extends Node2D

enum Effects {DODGE, SMEAR, SLASH, SHOCKWAVE}

var effect: Effects
var effect_data: Dictionary
var direction: int

func _ready() -> void:
	match effect:
		Effects.DODGE:
			$FreeTimer.start(1.0)
			var ghost_effect: GPUParticles2D = $Ghost
			effect_data.resource = effect_data.resource.left(effect_data.resource.length() - 4) # remove .png extension
			var texture: Texture2D = (
					load(effect_data.resource + "-mirrored.png") if direction < 0
					else load(effect_data.resource + ".png")
			)
			ghost_effect.texture = texture
			ghost_effect.emitting = true

		Effects.SMEAR:
			$AnimationPlayer.play("smear" + str(effect_data.variant))

		Effects.SLASH:
			$Slash.flip_h = effect_data.variant
			$AnimationPlayer.play("slash")

		Effects.SHOCKWAVE:
			$Shockwave.emitting = true


func _on_free_timer_timeout() -> void:
	queue_free()


func finish() -> void:
	match effect:
		Effects.SHOCKWAVE:
			$Shockwave.emitting = false
			$FreeTimer.start(0.5)

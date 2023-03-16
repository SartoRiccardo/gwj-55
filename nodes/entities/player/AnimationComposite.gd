extends CanvasGroup
class_name AnimationComposite


func play(animation_name : String) -> void:
	for anim in get_children():
		if anim.sprite_frames.has_animation(animation_name):
			anim.play(animation_name)
		else:
			anim.play("default")


func set_flip_h(flip_h : bool) -> void:
	for anim in get_children():
		anim.set_flip_h(flip_h)

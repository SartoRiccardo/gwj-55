extends CanvasGroup
class_name AnimationComposite


var flip_h := false


func play(animation_name : String) -> void:
	for anim in get_children():
		if anim.sprite_frames.has_animation(animation_name):
			anim.play(animation_name)
		else:
			anim.play("default")


func set_flip_h(new_flip_h : bool) -> void:
	flip_h = new_flip_h
	for anim in get_children():
		anim.set_flip_h(flip_h)


func is_flipped_h() -> bool:
	return flip_h

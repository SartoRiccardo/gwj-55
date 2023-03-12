extends CanvasLayer


@export var show_console : bool = true

var content : String = ""


func _ready():
	if not show_console:
		hide()


func _process(delta):
	$MarginContainer/PanelContainer/Label.set_text(content)
	content = ""


func writeln(line) -> void:
	content += str(line) + "\n"

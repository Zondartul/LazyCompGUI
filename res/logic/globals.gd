extends Node
class_name Globals

func warning(msg:String):
	push_warning(msg);

func error(msg:String):
	push_error(msg);
	exit();

func exit():
	get_tree().quit();

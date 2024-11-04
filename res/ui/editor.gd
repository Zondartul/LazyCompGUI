extends Control

const scene_file_panel = preload("res://res/ui/editor_file_panel.tscn")
@onready var tabs = $V/tabs
signal source_text_changed(text);

var files = [];

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _add_file_tab(file):
	file.panel = scene_file_panel.instantiate()
	file.panel.file_handle = file;
	file.panel.name = file.filename;
	tabs.add_child(file.panel);
	tabs.current_tab = tabs.get_children().size()-1;

func _on_file_new(file:FileHandle): 
	_add_file_tab(file);
	
func _on_file_open(file:FileHandle) -> void:
	print("editor: _on_file_open(%s)" % file.filename);
	_add_file_tab(file);
	files.append(file);
	file.panel.reload();
	# signal source text
	var S = file.fd.get_as_text();
	assert(S is String)
	source_text_changed.emit(S);
	

extends Control

const scene_file_panel = preload("res://res/ui/editor_file_panel.tscn")
@onready var tabs = $V/tabs

var files = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_file();
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_file_tab(file):
	file.panel = scene_file_panel.instantiate()
	file.panel.file_handle = file;
	file.panel.name = file.filename;
	tabs.add_child(file.panel);
	tabs.current_tab = tabs.get_children().size()-1;

func _add_file_descriptor(file, path):
	var fd = FileAccess.open(path, FileAccess.READ);
	if not fd.is_open(): G.warning("can't open file [%s]" % path); return;
	file.fd = fd;


func new_file():
	var file = FileHandle.new();
	file.filename = "New file";
	_add_file_tab(file);
	files.append(file);

func open_file():
	$fd_open_file.popup();

func _on_fd_open_file_file_selected(path: String) -> void:
	open_file_helper(path);

func open_file_helper(path: String):
	var file = FileHandle.new();
	_add_file_descriptor(file, path);
	file.filename = path.get_file();
	file.path = path.get_base_dir();
	_add_file_tab(file);
	files.append(file);
	file.panel.reload();

func _on_file_index_pressed(index: int) -> void:
	if index == 0: # New file
		new_file();
	elif index == 1: # Open File
		open_file();
	elif index == 2: # Save
		pass
	elif index == 3: # Save As
		pass
	else: assert(!"unhandled case");

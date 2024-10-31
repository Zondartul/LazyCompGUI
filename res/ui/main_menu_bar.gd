extends MenuBar

@onready var fd_open_file = $File/fd_open_file
@onready var fd_save_file = $File/fd_open_file
@onready var n_File = $File
signal file_open(path:String);
signal file_new();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	n_File.index_pressed.connect(_on_file_index_pressed);
	fd_open_file.file_selected.connect(_on_fd_open_file_file_selected);
	
	var dir_offset = "/../../symbolScript/data_out";
	fd_open_file.current_dir += dir_offset;
	fd_save_file.current_dir += dir_offset;
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_file_index_pressed(index: int) -> void:
	if index == 0: # New file
		file_new.emit()
	elif index == 1: # Open File
		fd_open_file.popup();
	elif index == 2: # Save
		pass
	elif index == 3: # Save As
		pass
	else: assert(false, "unhandled case");


func _on_fd_open_file_file_selected(path: String) -> void:
	file_open.emit(path);	

extends Node

signal new_file(file:FileHandle);
signal open_file(file:FileHandle);
signal extension_dispatch(mode:String, file:FileHandle, ext:String)

var files = [];
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _new_file():
	var file = FileHandle.new();
	file.filename = "New file";
	files.append(file);
	new_file.emit(file);
	return file;

func _add_file_descriptor(file, path):
	var fd = FileAccess.open(path, FileAccess.READ);
	if not fd.is_open(): G.warning("can't open file [%s]" % path); return;
	file.fd = fd;
	return fd;
	
func _open_file(path: String):
	var file = FileHandle.new();
	_add_file_descriptor(file, path);
	file.filename = path.get_file();
	file.path = path.get_base_dir();
	open_file.emit(file);
	var ext = path.get_extension();
	extension_dispatch.emit("open",file,ext);
	return file;
	
	
	
	

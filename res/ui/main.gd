extends Control

@onready var main_menu = $V/MenuBar
@onready var file_manager = $logic/file_manager
# Editor for source-code editing
@onready var view_editor = $V/TabContainer/Editor
# View of pre-processed text (e.g. #include and #define)
@onready var view_preproc = $V/TabContainer/Preproc
# View of tokenized code
@onready var view_tokens = $V/TabContainer/Tokens
# View of abstract syntax tree after code is parsed
@onready var view_parse = $"V/TabContainer/Parse (AST)"
# View of semantic information after the AST is analyzed
@onready var view_semantic = $V/TabContainer/Semantic
# View of backend-agnostic intermediate representation code
@onready var view_ir = $V/TabContainer/IR
# View of code-generator blocks, symbols and book-keeping info
@onready var view_codegen = $V/TabContainer/Codegen
# View of final assembly code
@onready var view_asm = $V/TabContainer/Asm
# View of execution result (terminal or other output)
@onready var view_exec = $V/TabContainer/Exec

@onready var views = {"editor":view_editor,
	"preproc":view_preproc,
	"tokens":view_tokens,
	"parse":view_parse,
	"semantic":view_semantic,
	"ir":view_ir,
	"codegen":view_codegen,
	"asm":view_asm,
	"exec":view_exec};

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu.file_open.connect(file_manager._open_file);
	main_menu.file_new.connect(file_manager._new_file);
	file_manager.extension_dispatch.connect(_on_extension_dispatch);
	view_editor.source_text_changed.connect(view_tokens._on_src_changed);
	view_editor.source_text_changed.connect(view_parse._on_src_changed);
	
	
	view_editor._on_file_new(file_manager._new_file());
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
	
func _on_extension_dispatch(mode,file,ext):
	print("dispatch %s %s %s " % [mode,file.filename,ext])
	if(ext in ["c", "cpp", "txt"]): 
		if(mode == "open"): view_editor._on_file_open(file);
	elif(ext in ["json"]):
		if(mode == "open"): _open_json_file(file);
	else:
		push_error("unknown file extension: "+str(ext));

func _open_json_file(file:FileHandle):
	var text = file.fd.get_as_text();
	var json = JSON.parse_string(text);
	assert(json != null);
	if(json["file_type"] == "tokens"):
		view_tokens._on_open_json(json);
	elif(json["file_type"] == "ast"):
		view_parse._on_open_json(json);
	else:
		assert(false, "unknown file type: don't know what this json is for")

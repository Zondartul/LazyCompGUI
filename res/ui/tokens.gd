extends Control

@onready var Text = $Text;

var tokens = [];
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

var type_colors = {
	"IDENT":Color.SKY_BLUE,
	"PUNCT":Color.GRAY,
	"NUMBER":Color.ORANGE,
	"ARRAY":Color.PURPLE,
	"VECTOR":Color.PURPLE,
	"MATRIX":Color.PURPLE,
	"STRING":Color.YELLOW,
	"COMMENT":Color.DARK_GREEN,
	"OP":Color.WHITE,
	"ERROR":Color.RED,
};

func _set_tok_color(tok:Dictionary):
	var col;
	if(tok.type in type_colors):
		col = type_colors[tok.type];
	else:
		col = type_colors["ERROR"];
	Text.push_color(col);

func _on_open_json(json:Dictionary):
	Text.clear();
	assert(json["file_type"] == "tokens");
	for jsn_tok in json["data"]:
		#print(jsn_tok);
		tokens.push_back(jsn_tok);
		_set_tok_color(jsn_tok);
		var current_tok_idx = tokens.size()-1;
		Text.push_meta(current_tok_idx, RichTextLabel.META_UNDERLINE_ON_HOVER);
		Text.add_text(jsn_tok["text"]);
		Text.pop_all();


func _on_text_meta_hover_started(meta: Variant) -> void:
	var tok_idx = meta;
	var tok = tokens[tok_idx];
	var tok_str = str(tok);
	print("mouseover: token "+tok_str);

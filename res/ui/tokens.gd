extends Control

@onready var Text = $H/Text;
@onready var cb_tooltip = $H/V/cb_tooltip;
@onready var p_tooltip = $p_tooltip;
@onready var p_tooltip_lbl = $p_tooltip/lbl;

var tokens = [];
var source_text;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cb_tooltip.pressed.connect(_on_cb_tooltip_pressed);
	pass # Replace with function body.

func _on_src_changed(text):
	source_text = text;

func _on_cb_tooltip_pressed()->void:
	if(cb_tooltip.button_pressed):	p_tooltip.show();
	else:							p_tooltip.hide();
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(cb_tooltip.button_pressed):
		const offset = Vector2(32,0);
		var pos = get_viewport().get_mouse_position();
		p_tooltip.global_position = pos+offset;
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
		var tok = TokenUtils.decompress_token(jsn_tok, json["dict"]);
		tokens.push_back(tok);
		
		# paint on the RichTextLabel:
		_set_tok_color(tok);
		var current_tok_idx = tokens.size()-1;
		Text.push_meta(current_tok_idx, RichTextLabel.META_UNDERLINE_ON_HOVER);
		Text.add_text(tok.text);
		Text.pop_all();


func _on_text_meta_hover_started(meta: Variant) -> void:
	if(cb_tooltip.button_pressed):
		var tok_idx = meta;
		var tok = tokens[tok_idx];
		
		p_tooltip_lbl.clear();
		p_tooltip_lbl.add_text("text: "+str(tok.text)+
		"\ntype: "+str(tok.type)+
		"\npos1:"+str(tok.pos1)+
		"\npos2:"+str(tok.pos2));
		
		#source text with margin, if any
		p_tooltip_lbl.add_text("\n");
		const margin = 5;
		var snips = TokenUtils.get_source_text(source_text, tok.pos1, tok.pos2, margin);
		if(snips.size() == 3):
			var margin1 = snips[0];
			var src = 	  snips[1];
			var margin2 = snips[2];
			p_tooltip_lbl.append_text("[color=gray]"+margin1+"[/color][color=white][u]"+src+"[/u][/color][color=gray]"+margin2+"[/color]");
		elif(snips.size() == 1):
			var src = snips[0];
			p_tooltip_lbl.append_text("[color=yellow]"+src+"[/color]");
		else:
			p_tooltip_lbl.append_text("[color=red](no src)[/color]");

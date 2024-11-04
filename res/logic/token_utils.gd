extends Node


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

static func decompress_tok_pos(pos_idx, dict:Dictionary):
	var pos = dict.positions[pos_idx];
	var res = {"char_idx":pos.p,
		"col":pos.c,
		"line":pos.l,
		"filename":dict.filenames[pos.f]};
	return res;

static func decompress_token(tok:Dictionary, dict:Dictionary):
	var res = tok.duplicate();
	res.pos1 = decompress_tok_pos(tok.pos1, dict);
	res.pos2 = decompress_tok_pos(tok.pos2, dict);
	return res;

static func get_source_text(source_text:String, pos1:Dictionary, pos2:Dictionary, margin=null) -> Array:
	if((pos1.char_idx == -1) or (pos2.char_idx == -1)): return ["(no src)"];
	var i1 = pos1.char_idx+1; # warning: correcting the bork bork
	var i2 = pos2.char_idx+1;
	assert((i1 != null) and (i2 != null))
	if(source_text is String and source_text.length()):
		if(margin == null):
			return [source_text.substr(i1, i2-i1)];
		else:
			var chm1 = max(i1-margin,0);
			var chm1_s = max(i1,0)-chm1;
			var S_margin1 = source_text.substr(chm1, chm1_s);
			var p1 = max(i1,0);
			var p2 = max(i2,0);
			var p1_s = p2-p1;
			var S_src = source_text.substr(p1,p1_s);
			var chm2 = p2;
			var chm2_s = margin;
			var S_margin2 = source_text.substr(chm2, chm2_s);
			return [S_margin1, S_src, S_margin2];
	return ["(no src)"];

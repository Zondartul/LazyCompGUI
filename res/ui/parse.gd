extends Control

@onready var Graph = $Graph

var nodeinfos = {};
var ni_root;
const ch_step = Vector2(0,120);
const scene_node_ast_graph = preload("res://res/ui/node_ast_graph.tscn")
var source_text;

class NodeInfo:
	var tok:Dictionary;
	var node_tok:GraphNode;
	var is_node_tok_open:bool;
	var ni_parent:NodeInfo;
	var ni_children:Array;

func _ready() -> void:
	OS.low_processor_usage_mode = true;
	#Graph.node_selected.connect(_on_node_selected);
	
func _lookup_src_text(pos1:Dictionary, pos2:Dictionary):
	return TokenUtils.get_source_text(source_text, pos1, pos2)[0];
	
func _on_src_changed(txt:String):
	source_text = txt;
	
func _make_node(ni:NodeInfo):
	var node = scene_node_ast_graph.instantiate(); #GraphNode.new();
	
	# slots
	node.set_slot(0,true,0,Color.WHITE,false,0,Color.WHITE)
	if(ni.ni_children):
		for i in range(ni.ni_children.size()):
			node.add_child(Control.new())
			node.set_slot(1+i,false,0,Color.WHITE,true,0,Color.WHITE);
		
	node.title = str(ni.tok.type);
	#var lbl1 = node.find_child("lbl_text");
	#lbl1.text = str(ni.tok.type);
	var rtl2 = node.find_child("rtl_src");
	if(ni.tok.text.length() != 0): rtl2.append_text("[color=yellow]%s[/color]\n" % str(ni.tok.text));
	rtl2.append_text("[color=dark gray]pos1: %d, pos2: %d[/color]\n" % [ni.tok.pos1.char_idx, ni.tok.pos2.char_idx]);
	rtl2.add_text(_lookup_src_text(ni.tok.pos1, ni.tok.pos2));
	# VBox to hold everything
	#var Vbox = VBoxContainer.new()
	#node.add_child(Vbox);
	#Vbox.size = node.size;
	#Vbox.anchor_bottom = ANCHOR_END;
	#Vbox.anchor_top = ANCHOR_BEGIN;
	#Vbox.anchor_left = ANCHOR_BEGIN;
	#Vbox.anchor_right = ANCHOR_END;
	# title and body text
	#node.title = str(ni.tok.text);
	#var lbl = Label.new();
	#lbl.text = str(ni.tok.type);
	#Vbox.add_child(lbl);
		
	# source text
	#var lbl2 = Label.new();
	#lbl2.text = _lookup_src_text(ni.tok.pos1, ni.tok.pos2);
	#Vbox.add_child(lbl2);
		
	# button for more children
	var btn = node.find_child("btn_children"); #Button.new();
	if(ni.ni_children):
		btn.text = "%d >" % ni.ni_children.size()
		#btn.size_flags_horizontal = Control.SIZE_EXPAND;
		#btn.size_flags_vertical = Control.SIZE_EXPAND;
		#Vbox.add_child(btn);
		btn.pressed.connect(_on_node_selected.bind(node));
	else:
		btn.hide();
	return node;



var max_ast_nodes = 0;

func _ast_to_nodeinfo(ast, parent, dict):
	var ni = NodeInfo.new();
	ni.tok = TokenUtils.decompress_token(ast.tok, dict);
	ni.ni_parent = parent;
	ni.node_tok = null;
	ni.is_node_tok_open = false;
	
	if(ast.children):
		ni.ni_children = [];
		for ch in ast.children:
			ni.ni_children.append(_ast_to_nodeinfo(ch,ni,dict));
	return ni;

func _instance_ni(ni:NodeInfo, pos:Vector2):
	if max_ast_nodes == 0: return null;
	max_ast_nodes -= 1;
	var node = _make_node(ni);
	Graph.add_child(node);
	node.position_offset = pos;
	nodeinfos[node] = ni;
	ni.node_tok = node;
	if(ni.ni_parent):
		var node_parent = ni.ni_parent.node_tok;
		assert(node_parent != null);	
	return node;

func _deinstance_ni(ni:NodeInfo):
	max_ast_nodes += 1;
	assert(ni.node_tok);
	assert(ni.is_node_tok_open == false)
	var node = ni.node_tok;
	ni.node_tok = null;
	nodeinfos.erase(node);
	node.clear_all_slots();
	node.queue_free();
		
func _clear_graph():
	## WARNING: removing all children of a GraphEdit causes a crash
	#for ch in Graph.get_children(): ch.queue_free();
	nodeinfos = {};
	ni_root = null;
	Graph.clear_connections();
	for ch in Graph.get_children():
		if ch is GraphNode:
			ch.queue_free();
	max_ast_nodes = -1;
	
func _on_open_json(json:Dictionary):
	assert(json["file_type"] == "ast");
	_clear_graph();
	ni_root = _ast_to_nodeinfo(json["data"],null,json["dict"]);
	_instance_ni(ni_root,Vector2(0,0));
	pass

func _on_node_selected(node):
	#print("node selected: node [%s]" % node.name);
	var ni = nodeinfos[node];
	if ni.is_node_tok_open:	_close_ni(ni);
	else:					_open_ni(ni);
	
func _move_neighbors_down(ni:NodeInfo): _move_neighbors(ni,true)
func _move_neighbors_up(ni:NodeInfo): _move_neighbors(ni,false);
func _move_neighbors(ni:NodeInfo, down:bool):
	# move everything below this node down by ch_pos
	var node = ni.node_tok;
	
	#var step = ch_step;
	#if not down: step.y = -step.y;
	#var offset = step*ni.ni_children.size();
	var offset = Vector2(0,node.size.y);
	if not down: offset.y = -offset.y;
	
	for node_i in nodeinfos.keys():
		var ni2 = nodeinfos[node_i]
		if(ni2.node_tok):
			var node2 = ni2.node_tok;
			if(node2.position_offset.y > node.position_offset.y):
				node2.position_offset += offset;
	
func _graphnode_get_corners(node):
	var np:Vector2 = node.position_offset;
	var ns:Vector2 = node.size;
	var c_nw = Vector2(np.x, np.y);
	var c_ne = Vector2(np.x + ns.x, np.y);
	var c_sw = Vector2(np.x, np.y+ns.y);
	var c_se = Vector2(np.x + ns.x, np.y+ns.y);
	return {"nw":c_nw, "ne":c_ne, "sw":c_sw, "se":c_se};
	
func _open_ni(ni:NodeInfo):
	if(ni.ni_children == null): return;
	assert(ni.is_node_tok_open == false);
	ni.is_node_tok_open = true;
	var corner = _graphnode_get_corners(ni.node_tok).ne;
	var ch_offset = corner + Vector2(32,0);
	var ch_pos = Vector2(0,0);
	_move_neighbors_down(ni);

	var node_pr = ni.node_tok;
	var idx = 0;
	for ni_ch in ni.ni_children:
		var ch_node = _instance_ni(ni_ch, ch_offset + ch_pos);
		#var ch_corner = _graphnode_get_corners(ch_node).sw;
		ch_pos.y += ch_node.size.y;#(ch_corner - ch_offset);
		var node_ch = ni_ch.node_tok;
		Graph.connect_node(node_pr.name,idx,node_ch.name,0);
		idx += 1;
		ch_pos += ch_step;
	
func _close_ni(ni:NodeInfo):
	if(ni.ni_children == null): return;
	assert(ni.is_node_tok_open == true);
	ni.is_node_tok_open = false;
	for ni_ch in ni.ni_children:
		if(ni_ch.is_node_tok_open): _close_ni(ni_ch);
		_deinstance_ni(ni_ch);
	_move_neighbors_up(ni);

extends Control

@onready var Graph = $Graph

var nodeinfos = {};
var ni_root;
const ch_step = Vector2(0,80);

class NodeInfo:
	var tok:Dictionary;
	var node_tok:GraphNode;
	var is_node_tok_open:bool;
	var ni_parent:NodeInfo;
	var ni_children:Array;

func _ready() -> void:
	OS.low_processor_usage_mode = true;
	#Graph.node_selected.connect(_on_node_selected);
	
func _make_node(ni:NodeInfo):
	var node = GraphNode.new();
	
	# slots
	node.set_slot(0,true,0,Color.WHITE,false,0,Color.WHITE)
	if(ni.ni_children):
		for i in range(ni.ni_children.size()):
			node.add_child(Control.new())
			node.set_slot(1+i,false,0,Color.WHITE,true,0,Color.WHITE);
		
	# VBox to hold everything
	var Vbox = VBoxContainer.new()
	node.add_child(Vbox);
	Vbox.size = node.size;
	
	# title and body text
	node.title = str(ni.tok.text);
	var lbl = Label.new();
	lbl.text = str(ni.tok.type);
	Vbox.add_child(lbl);
		
	# button for more children
	if(ni.ni_children):
		var btn = Button.new();
		btn.text = "%d children" % ni.ni_children.size()
		btn.size_flags_horizontal = Control.SIZE_EXPAND;
		btn.size_flags_vertical = Control.SIZE_EXPAND;
		Vbox.add_child(btn);
		btn.pressed.connect(_on_node_selected.bind(node));
	return node;

var max_ast_nodes = 0;

func _ast_to_nodeinfo(ast, parent):
	var ni = NodeInfo.new();
	ni.tok = ast.tok;
	ni.ni_parent = parent;
	ni.node_tok = null;
	ni.is_node_tok_open = false;
	
	if(ast.children):
		ni.ni_children = [];
		for ch in ast.children:
			ni.ni_children.append(_ast_to_nodeinfo(ch,ni));
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
	Graph.clear_connections();
	for ch in Graph.get_children():
		if ch is GraphNode:
			ch.queue_free();
	max_ast_nodes = -1;
	
func _on_open_json(json:Dictionary):
	assert(json["file_type"] == "ast");
	_clear_graph();
	ni_root = _ast_to_nodeinfo(json["data"],null);
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
	var step = ch_step;
	if not down: step.y = -step.y;
	# move everything below this node down by ch_pos
	var node = ni.node_tok;
	for node_i in nodeinfos.keys():
		var ni2 = nodeinfos[node_i]
		if(ni2.node_tok):
			var node2 = ni2.node_tok;
			if(node2.position_offset.y > node.position_offset.y):
				node2.position_offset += step*ni.ni_children.size();
	
func _open_ni(ni:NodeInfo):
	if(ni.ni_children == null): return;
	assert(ni.is_node_tok_open == false);
	ni.is_node_tok_open = true;
	var ch_offset = Vector2(300,80);
	var ch_pos = ni.node_tok.position_offset;
	
	_move_neighbors_down(ni);

	var node_pr = ni.node_tok;
	var idx = 0;
	for ni_ch in ni.ni_children:
		_instance_ni(ni_ch, ch_offset + ch_pos);
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

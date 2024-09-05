extends Control

var file_handle = null;

func _ready():
	$TextEdit.syntax_highlighter = make_syntax_highlighter();

func make_syntax_highlighter():
	#var HL:CodeHighlighter = $TextEdit.syntax_highlighter;
	var HL:CodeHighlighter = CodeHighlighter.new()
	
	var col_normal = Color.from_string("9cdcfe", Color.BLACK); #Color.SKY_BLUE;
	var col_number = Color.LIGHT_GREEN;
	var col_keywords = Color.from_string("c586c0", Color.BLACK);#Color.REBECCA_PURPLE;
	var col_types = Color.from_string("569cd6", Color.BLACK);#Color.ROYAL_BLUE;
	var col_strings = Color.from_string("da8355", Color.BLACK);#Color.INDIAN_RED;
	var col_comments = Color.from_string("688e54", Color.BLACK);#Color.WEB_GREEN;
	var col_function = Color.from_string("dcdcaa", Color.BLACK);#Color.WHEAT;
	var col_escape = col_normal;
	var col_error = Color.RED;
	HL.symbol_color = col_normal;
	HL.number_color = col_number;
	HL.function_color = col_function;
	HL.member_variable_color = col_normal;
	
	HL.add_color_region("//", "", col_comments, true);
	HL.add_color_region("/*", "*/", col_comments);
	HL.add_color_region("\"", "\"", col_strings);
	HL.add_color_region("#", " ", col_keywords);
	var keywords = ["include", "return", "class", "varargs", "asm", "end", "if", "else", "elseif", "while", "for"];
	var escape_chars = ["%s", "%c", "%d", "\\n", "\\r", "\\0", "\\b", "\\t", "\\\\"];
	
	var types = ["int", "float", "char", "void", "string"];
	for w in keywords:		HL.add_keyword_color(w, col_keywords);
	for w in types:			HL.add_keyword_color(w, col_types);
	
	HL.add_keyword_color("%", col_error);
	HL.add_keyword_color("\\", col_error);
	for w in escape_chars:	HL.add_keyword_color(w, col_escape);
	return HL;

func reload():
	assert(file_handle);
	var text = file_handle.fd.get_as_text();
	$TextEdit.text = text;

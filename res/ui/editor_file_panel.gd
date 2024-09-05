extends Control

var file_handle = null;

func reload():
	assert(file_handle);
	var text = file_handle.fd.get_as_text();
	$TextEdit.text = text;

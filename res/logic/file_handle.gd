extends Node
class_name FileHandle

@export var filename:String
@export var path:String
var modified:bool = false;
var panel = null; # gui element that works as a view for this file
var fd = null; # file descriptor

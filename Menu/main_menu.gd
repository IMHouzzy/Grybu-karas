class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button as Button
@onready var quit_button = $MarginContainer/HBoxContainer/VBoxContainer/Quit_Button as Button
@onready var options_menu = $Options_Menu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer

@onready var start_level_1 = preload("res://Assets/level/level_1_.tscn") as PackedScene

func _ready():
	handle_connecting_signals()

func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_button_down)
	options_button.button_down.connect(on_options_button_down)
	quit_button.button_down.connect(on_quit_button_down)
	options_menu.exit_options_menu.connect(on_back_button_down)

func on_start_button_down() -> void:
	get_tree().change_scene_to_packed(start_level_1)

func on_options_button_down() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func on_quit_button_down() -> void:
	get_tree().quit()

func on_back_button_down() -> void:
	margin_container.visible = true
	options_menu.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




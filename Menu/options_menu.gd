class_name OptionsMenu
extends Control

@onready var back_button = $MarginContainer/VBoxContainer/Back_Button as Button

signal exit_options_menu

func _ready():
	handle_connecting_signals()
	set_process(false)

func handle_connecting_signals() -> void:
	back_button.button_down.connect(on_back_button_down)

func on_back_button_down() -> void:
	exit_options_menu.emit()
	set_process(false)

func _process(delta):
	pass

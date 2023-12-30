extends Control

@onready var app_name = "MyCollection"
@onready var version = "1.0.1"

@onready var screen_size = DisplayServer.screen_get_size()
@onready var window_size = DisplayServer.window_get_size()
@onready var movie_list = []
@onready var search_wait = true
@onready var window_mode = 0
@onready var grid_columns = 5
@onready var grid_rows = 2

@onready var grid = $VBoxContainer/ScrollContainer/MarginContainer/GridContainer
@onready var searchbar = $VBoxContainer/MarginContainer/HBoxContainer/LineEdit
@onready var items_amount = $VBoxContainer/MarginContainer/HBoxContainer/Label
@onready var searching_wait = $ColorRect

@onready var path = "/media/sda7/Programming/Godot4/movies"


func _ready():
	# set app name
	DisplayServer.window_set_title(app_name + " " + version)
	
	# hide loading screen
	searching_wait.visible = false
	
	# get path
	path = get_app_path()
	
	# read config
	read_config(path)

	# get movie list folders
	movie_list = get_files(path, "folders")
	print(movie_list)
	
	#show movies
	load_movies(movie_list)

	# resize signal
	get_tree().get_root().size_changed.connect(set_sizes)
	
	# grab focus on search bar
	searchbar.grab_focus()
	
	# set window mode button sizes
	DisplayServer.window_set_mode(window_mode)
	set_sizes()
	


func get_app_path():
	#var path = ""
	if OS.has_feature("editor"):
		#path = ProjectSettings.globalize_path("res://") # use this to set it to res://
		pass
	else:
		path = OS.get_executable_path().get_base_dir()
	path = path.path_join("") # + "/"
	print(path)
	return path



func read_config(config_path):
	var config_file = FileAccess.open(config_path + "MyCollection.cfg", FileAccess.READ)
	if config_file:
		var config = JSON.parse_string(config_file.get_as_text())
		print(config)
		grid_columns = int(config["grid_columns"])
		grid_rows = int(config["grid_rows"])
		window_mode = int(config["window_mode"])
		var new_path = config["collection_path"]
		if new_path != "":
			path = new_path
		
	
	
func set_sizes():
	grid.columns = grid_columns
	window_size = DisplayServer.window_get_size()
	for child in grid.get_children():
		child.custom_minimum_size.x = window_size.x/grid_columns - 30
		child.custom_minimum_size.y = window_size.y/grid_rows - 44#45
		
		

func get_files(path, what):
	var folders = []
	var files = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var item = dir.get_next()
		while item != "":
			if dir.current_is_dir():
				folders.append(item)
			else:
				files.append(item)
			item = dir.get_next()
		folders.sort()
		files.sort()
	if what == "folders":
		return folders
	elif what == "files":
		return files
	else:
		return folders + files
	
	
	
func create_movie_title(movie_title):
		var factor = len(movie_title)/24.0
		if factor > 1:
			for i in range(int(factor)):
				movie_title = movie_title.insert(24*(i+1), "\n")
		return movie_title
	
	
	
func load_movies(movie_list):
	# clear grid straight away
	for child in grid.get_children():
		child.free()
		
	# show movies
	for movie in movie_list:
		var button = Button.new()
		button.name = movie
		
		# set movie title
		button.text = create_movie_title(movie)
		
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		#button.size_flags_vertical = SIZE_EXPAND_FILL
		
		# get first image file
		var movie_files = get_files(path.path_join(movie), "all")
		var image_file = ""
		for file in movie_files:
			if file.ends_with(".jpg") or file.ends_with(".png"):
				image_file = file
				break
				
		# load image from disk
		var image = Image.new()
		image.load(path.path_join(movie).path_join(image_file))
		var image_texture = ImageTexture.new()
		image_texture.set_image(image)
		
		# set button image
		button.icon = image_texture
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		button.expand_icon = true

		# set tooltip
		var tooltip_text = ""
		for i in movie_files:
			tooltip_text += i + "\n"
		button.tooltip_text = tooltip_text
		
		# connect signal
		button.pressed.connect(open_folder.bind(path + movie))
		
		# create button
		grid.add_child(button)
		
	# set button size
	set_sizes()
	
	#show amount of items
	count_visible_items()

	


func open_folder(path):
	print("Open: " + path)
	OS.shell_open(path)
	
	
	
func _on_search_text_changed(new_text):
	if search_wait == true:
		# show loading screen
		searching_wait.visible = true
		
		# wait and search
		search_wait = false
		await get_tree().create_timer(0.75).timeout
		on_search(searchbar.text)
		search_wait = true



func on_search(new_text):
	print("Search: " + new_text)
	# if searchbar is empty, show all
	if new_text == "":
		for child in grid.get_children():
			child.visible = true
	
	# filter buttons
	else:
		for child in grid.get_children():
			if new_text.to_lower() in child.name.to_lower():
				child.visible = true
			else:
				child.visible = false
				
	# hide loading screen
	searching_wait.visible = false
	
	#show amount of items
	count_visible_items()
	
	
	
	
func count_visible_items():
	var items_visible = 0
	for i in grid.get_children():
		if i.visible == true:
			items_visible += 1
	items_amount.text = str(items_visible)
	
	
	
# shortcuts
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

	if event.is_action_pressed("escape"):
		searchbar.clear()

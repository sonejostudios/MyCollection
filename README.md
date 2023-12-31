# MyCollection
A Simple Collection Browser for Movies, Music, etc. Netflix style for local files :)



__Description:__

MyCollection is a simple and small tool to show collections of things (e.g. movies) in a nice way, showing posters as buttons. It will create one button for each folder and show them in a scrollable and searchable grid of items. It is written in Godot/GDScript.


![screenshot](https://github.com/sonejostudios/MyCollection/blob/main/MyCollection.png "MyCollection")



__Main Features:__

* Really simple and straight forward
* Open its own location as main folder
* Show the first image file found in folder
* Search/filter titles
* Show amount of item found
* Tooltips with the folder's files
* Optional config file


__Installation:__

Just copy the application file (see Releases) to your collection root folder and run it.
* On Linux, copy and run "MyCollection"
* On Windows, copy and run "MyCollection.exe"


__Usage:__

After launching it, it will scan its own folder (this can take time depending on the size of your collection/) and show a grid of buttons with images (only .jpg and .png) and titles. 
E.g. for a movie collection, it will show the posters and the folder's titles.
Hovering the button will show the folder's files in the tooltip.
Left click on the button will open the corresponding folder.
You can search for items with the search bar (the search bar gets focus on start).


__Keyboard Shortcuts:__

* Escape: clear the search bar and show all items
* F11: toggle window maximing


__Optional config file:__

In case you want to start the app in a special way, you can create a config file and change things there.
Or for simplicity, just download the example in this repo to the application folder and change the parameters.
You can change:
* Amount of columns
* Abount of rows
* Window mode
* Collection path

This file's name must be "MyCollection.cfg" and it should be a plain text file with json content:

```
{
"grid_columns": 5,
"grid_rows": 2,
"window_mode": 0,
"collection_path": "",
}
```

Grid columns and rows:

Depending of your screen resolution and the type of items, it could be interesting to change the amount of columns and rows. Try around what fits best. 5 and 2 is a good choice for movie posters, for music album covers try 7 and 3.

Window mode:

* 0: windowed (default)
* 1: minimized
* 2: maximized
* 3: fullscreen (use alt+F4 to close the app)

Collection path:

If empty, it will take the application's path. Otherwise, to set up  a default path:
* On Linux, use something like "/path/to/my/collection"
* On Windows, use something link "C:\path\to\my\collection"

If something went wrong, just delete the config file and restart the app.


__Optional script to create one folders for each file (Linux only):__

If your collection is not based on folders, but on files, you can use this little help bash script: CreateFolders4Files.sh.
For each file it will create a folder with the file name (without extention) and move the file into it. Be careful, this can't be undone. Maybe try in a test folder before running it on your full collection.
To run it, copy CreateFolders4Files.sh to you collection folder, open a terminal there and type:

```
sh CreateFolders4Files.sh
```






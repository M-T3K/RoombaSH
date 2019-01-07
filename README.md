# RoombaSH

A simple, 1 file, cleaner written in BASH.

## How it works

Take a look at the usage example [myscript.sh](). RoombaSH is very easy to set up, and once set up, it uses a special file called **.cleanup** to identify the files and directories it needs to clean. When parsing this file, directories and files are automatically identified.
Then it perfoms the cleanup with the function **roombash_do_cleanup**, your code is executed, and then it tries to bring things back to their previous status with **roombash_undo_cleanup**.

## Structure of the CleanUp file

It also supports comments using the **!** symbol. Any line commented will be automatically ignored upon cleanup.

- **PATH/TO/FILE**. Examples:
    - **file.txt** : This will store **file.txt** for cleanup.
    - **files/file.txt** : This will store **file.txt** that is located in /files/ for cleanup.
    - **files/files2/file.txt** : This will store the **file.txt** that is located in **/files/files2/** for cleanup.

- **PATH/TO/DIRECTORY**. Examples:
    - **tests/remove_this_dir/** : This will remove the directory called **/remove_this_dir/** under **/tests/**.
    - Let's say you wanted to remove a folder but keep its file. Then, you would need to specify the files first and then the folder. Like this:
        - `folder/folder2/save_this.txt`
        - `folder/folder2/`
        - This will save **save_this.txt** upon cleanup and delete `folder/folder2/`. However, when **roombash_undo_cleanup** is called, `folder/folder2/` will be created again, since it is necessary for `folder/folder2/save_this.txt`. All other files won't be there.
- **Comments**: Everything marked with **!** is ignored during cleanup.

## Improvements

- Have an option to mark all the files in a folder for CleanUp in just one line.
- Have an option to mark a file for CleanUp but not **undo_cleanup**.

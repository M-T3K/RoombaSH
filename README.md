# RoombaSH

A simple, 1 file, cleaner written in BASH.

## Story

The first version of RoombaSH was a small script that automatically uploaded an entire folder throuh ssh for one of my classes. After that, I started helping people and before I realized, my folder was full of files that weren't part of my homework, so uploading my stuff became tedius. I decided it was time to improve the uploading script, and RoombaSH was born.

## How it works

Take a look at the usage example [myscript.sh](https://github.com/M-T3K/RoombaSH/blob/master/myscript.sh).

RoombaSH is very easy to set up: it can be done in just 5 lines of short statements. Once set up, it uses a special file called **.cleanup** to identify the files and directories it needs to clean.
Then it perfoms the cleanup with the function **roombash_cleanup** (aka cleanup or cleaned up, depending on context), your code is executed, and then it tries to restore things to the state they were previously in with **roombash_restore** (aka restore or restored, depending on context).

## Structure of the CleanUp file

This is the structure that your **.cleanup** file should follow. You should also take a look at the usage example file [.cleanup](https://github.com/M-T3K/RoombaSH/blob/master/.cleanup).

- **PATH/TO/FILE**. Examples:
    - **file.txt** : This will store **file.txt** for cleanup.
    - **files/file.txt** : This will store **file.txt** that is located in /files/ for cleanup.
    - **files/files2/file.txt** : This will store the **file.txt** that is located in **/files/files2/** for cleanup.

- **PATH/TO/DIRECTORY**. Examples:
    - **tests/remove_this_dir/** : This will remove the directory called **/remove_this_dir/** under **/tests/**.
    - Let's say you wanted to remove a folder but keep its file. Then, you would need to specify the files first and then the folder. Like this:
        - `folder/folder2/save_this.txt`
        - `folder/folder2/`
        - This will save **save_this.txt** upon cleanup and delete `folder/folder2/`. However, when restore is called, `folder/folder2/` will be created again, since it is necessary for `folder/folder2/save_this.txt`. All other files won't be there.
- **Comments**: Everything marked with **!** is ignored during cleanup.
- **Unclean Annotation**: Expressed by a **^**, an unclean annotation specifies that a file or directory should be cleaned up but not restored.
- **Deep Annotation**: If **>** is in front of a directory in **.cleanup**, it means that the entire directory (including its contents) should be put up for cleanup.
- **Combining Annotations**: Unclean and Deep Annotations can be combined. To do so, you must type **^>**. This means that the directory is **Deeply Unclean**. Note that **>^** does not work, as they are not the same thing. 

## Improvements

Improve code Readability.

## Known Issues

So far, none.

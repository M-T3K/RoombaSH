

function errcho() {
    echo "$@" 1>&2;
}

function roombash_on_load() {

    echo "RoombaSH has loaded correctly"
}

function roombash_do_cleanup() {

    if [ ! -f ".cleanup" ]; then
        echo ".cleanup not found. Creating..."
        touch .cleanup
        return
    fi
    FILES=$(cat .cleanup)
    echo "@CleanUp: Performing CleanUp on {"$FILES"}" 
    mkdir "cleanup_storage"
    for FILE in $FILES; do
        if [[ ${FILE:0:1} == "!" ]]; then
            echo "IGNORE::$FILE"
            continue
        fi
        if [ -f $FILE ]; then
            echo "Saving File::"$FILE""
            DIR=$(dirname "$FILE")
            echo "DIRECTORY::$DIR"
            echo "" >> $FILE
            echo "$DIR" >> $FILE
            mv $FILE "cleanup_storage/"
        elif [ -d $FILE ]; then
            echo "Removing Directory::"$FILE"";
            rm -r $FILE
        else
            echo "Can't find "$FILE""
        fi
    done
}

function roombash_undo_cleanup() {

    for FILE in ./cleanup_storage/*; do
        echo "Moving "$FILE" back."
        # We obtain the previous path from the file
        PREV_PATH=$(tail -n1 $FILE)
        if [ ! -d $PREV_PATH ]; then
            echo "Directory::$PREV_PATH not found. Creating..."
            if ! mkdir $PREV_PATH; then
                errcho "Couldn't create Directory::$PREV_PATH. Something went wrong."
            fi
        fi
        # We remove the last line of the file (the previous path)
        sed -i '$d' $FILE
        echo "("$FILE")->("$PREV_PATH")"
        # We finally move
        mv $FILE $PREV_PATH
    done 
}

# To Test on Load

roombash_on_load
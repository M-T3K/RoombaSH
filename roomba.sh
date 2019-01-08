

function errcho() {
    echo "$@" 1>&2;
}



function roombash_on_load() {

    echo "RoombaSH has loaded correctly"
}

function roombash_cleanup() {

    if [ ! -f ".cleanup" ]; then
        echo ".cleanup not found. Creating..."
        touch .cleanup
        return
    fi

    FILES=$(cat .cleanup)
    echo "RoombaSH: Performing CleanUp on {"$FILES"}" 
    mkdir "RoombaSH: Creating Folder \"cleanup_storage\""

    for FILE in $FILES; do
        UNCLEAN=0   # This is a bad variable name..
        ALL_IN=0

        if [[ ${FILE:0:1} == "!" ]]; then
            echo "RoombaSH: Ignoring \"$FILE\""
            continue
        fi
        if [[ ${FILE:0:1} = "^" ]]; then
            FILE=${FILE#"^"} # Remove '^'
            echo "RoombaSH: \"$FILE\" is set to not be restored."
            let UNCLEAN=1
        fi
        if [[ ${FILE:0:1} = ">" ]]; then
            FILE=${FILE#">"} # Remove '#'
            echo "RoombaSH: \"$FILE\" is set for Deep Cleanup."
            let ALL_IN=1
        fi

        DIR=$(dirname "$FILE")
        echo "DIRECTORY::$DIR"
        if [ -f $FILE ]; then
            echo "RoombaSH: Cleaning up FILE: \"$FILE\"."
            echo "" >> $FILE
            echo "$DIR" >> $FILE
            if [ "$UNCLEAN" -eq 1 ]; then
                BASE_NAME=$(basename "$FILE")
                NEW_NAME="$DIR/^$BASE_NAME"
                mv $FILE $NEW_NAME
                mv $NEW_NAME "cleanup_storage/"
            else
                mv $FILE "cleanup_storage/"
            fi
        elif [ -d $FILE ]; then
            echo "RoombaSH: Cleaning up DIRECTORY: \"$FILE\"";
            if [ "$ALL_IN" -eq 1 ]; then
                INFO_FILE="$FILE/.cleanupinfo"
                touch $INFO_FILE
                if [ "$UNCLEAN" -eq 1 ]; then
                    DIR="^${DIR}"
                fi
                echo "$DIR" >> $INFO_FILE
                mv -v -f $FILE "cleanup_storage/"
            else 
                rm -r $FILE
            fi
        else
            errcho "RoombaSH: Couldn't find "$FILE""
        fi
    done
}

function roombash_restore() {

    for FILE in ./cleanup_storage/*; do
        echo "RoombaSH: Restoring \"$FILE\"..."
        FILE_NAME=$(basename "$FILE")
        if [[ ${FILE_NAME:0:1} == "^" ]]; then
            echo "RoombaSH: FILE \"$FILE\" is not set for Restoration. Ignoring..."
            continue
        fi
        if [[ -d $FILE ]]; then
            INFO_FILE="$FILE/.cleanupinfo"
            PREV_PATH=$(cat $INFO_FILE)
            if [ "${PREV_PATH:0:1}" == "^" ]; then
                echo "RoombaSH: Directory \"$FILE\" is not set for Restoration. Ignoring..."
                continue
            fi
            rm $INFO_FILE
            mv -v -f $FILE $PREV_PATH
            continue;
        fi
        # We obtain the previous path from the last line of the file
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
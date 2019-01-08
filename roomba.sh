

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
    echo "@CleanUp: Performing CleanUp on {"$FILES"}" 
    mkdir "cleanup_storage"
    for FILE in $FILES; do
        UNCLEAN=0
        ALL_IN=0
        if [[ ${FILE:0:1} == "!" ]]; then
            echo "IGNORE::$FILE"
            continue
        fi
        if [[ ${FILE:0:1} = "^" ]]; then
            echo "UNCLEAN::$FILE"
            FILE=${FILE#"^"}
            echo "NEW FILE NAME: $FILE"
            let UNCLEAN=1
        fi
        if [[ ${FILE:0:1} = ">" ]]; then
            echo "ALL_IN::$FILE"
            FILE=${FILE#">"}
            echo "NEW FILE NAME: $FILE"
            let ALL_IN=1
        fi
        DIR=$(dirname "$FILE")
        echo "DIRECTORY::$DIR"
        if [ -f $FILE ]; then
            echo "Saving File::"$FILE""
            echo "" >> $FILE
            echo "$DIR" >> $FILE
            if [ "$UNCLEAN" -eq 1 ]; then
                echo "UNCLEAN::$FILE"
                new_file_name=$(basename "$FILE")
                file_ext="${new_file_name##*.}"
                new_file_name="${new_file_name%.*}.$file_ext"
                COMP_FILE_NAME="$DIR/^$new_file_name"
                mv $FILE $COMP_FILE_NAME
                mv $COMP_FILE_NAME "cleanup_storage/"
            else
                mv $FILE "cleanup_storage/"
            fi
        elif [ -d $FILE ]; then
            echo "Removing Directory::"$FILE"";
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
            echo "Can't find "$FILE""
        fi
    done
}

function roombash_restore() {

    for FILE in ./cleanup_storage/*; do
        echo "Moving "$FILE" back."
        file_name=$(basename "$FILE")
        if [[ ${file_name:0:1} == "^" ]]; then
            continue
        fi
        if [[ -d $FILE ]]; then
            INFO_FILE="$FILE/.cleanupinfo"
            PREV_PATH=$(cat $INFO_FILE)
            if [ "${PREV_PATH:0:1}" == "^" ]; then
                echo "$FILE is UNCLEAN. Not Restoring."
                continue
            fi
            rm $INFO_FILE
            mv -v -f $FILE $PREV_PATH
            continue;
        fi
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
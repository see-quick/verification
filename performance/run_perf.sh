#!/bin/bash

RUNS=${1:-5}
LANGUAGE_DIRS=$(find . -maxdepth 1 -type d ! -name "." | sed 's|./||')

for LANG in $LANGUAGE_DIRS; do
  EXPERIMENT_DIRS=$(find "$LANG" -maxdepth 1 -type d ! -name "$LANG" | sort)
  
  for EXP_DIR in $EXPERIMENT_DIRS; do
    EXEC="sum_${LANG}"
    echo -e "\n${EXP_DIR} Performance:"

    pushd "$EXP_DIR" > /dev/null

    if [ ! -f "$EXEC" ]; then
      echo "Compiling $EXP_DIR..."
      if [ "$LANG" = "go" ]; then
        go build -o $EXEC main.go
      elif [ "$LANG" = "rust" ]; then
        rustc -C opt-level=3 main.rs -o $EXEC
      fi
    fi

    for i in $(seq 1 $RUNS); do
      echo "Run #$i:"
      time ./$EXEC
    done

    popd > /dev/null
  done
done

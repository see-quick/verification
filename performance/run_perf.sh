#!/bin/bash

RUNS=${1:-5}
LANGUAGE_DIRS=$(find . -maxdepth 1 -type d ! -name "." | sed 's|./||')

# Color codes using tput
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

for LANG in $LANGUAGE_DIRS; do
  EXPERIMENT_DIRS=$(find "$LANG" -maxdepth 1 -type d ! -name "$LANG" | sort)

  for EXP_DIR in $EXPERIMENT_DIRS; do
    EXEC="sum_${LANG}"
    echo -e "\n${BLUE}==> ${EXP_DIR} Performance:${RESET}"

    pushd "$EXP_DIR" > /dev/null

    if [ ! -f "$EXEC" ]; then
      echo -e "${YELLOW}Compiling $EXP_DIR...${RESET}"
      if [ "$LANG" = "go" ]; then
        go build -o $EXEC main.go
      elif [ "$LANG" = "rust" ]; then
        rustc -C opt-level=3 main.rs -o $EXEC
      fi
    fi

    for i in $(seq 1 $RUNS); do
      echo -e "${CYAN}Run #$i:${RESET}"
      time ./$EXEC
    done

    popd > /dev/null
  done
done

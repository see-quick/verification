#!/bin/bash

RUNS=${1:-5}
EXPERIMENT_FILTER=${2:-""}  # Optional second argument to filter experiments
CLEAN=${3:-""}  # Optional third argument to clean binaries
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
    if [[ -n "$EXPERIMENT_FILTER" && "$EXP_DIR" != *"$EXPERIMENT_FILTER"* ]]; then
      continue
    fi

    EXEC="sum_${LANG}"
    
    if [[ "$CLEAN" == "clean" ]]; then
      echo -e "${RED}Cleaning $EXP_DIR...${RESET}"
      rm -f "$EXP_DIR/$EXEC"
      continue
    fi
    
    echo -e "\n${BLUE}==> ${EXP_DIR} Performance:${RESET}"

    pushd "$EXP_DIR" > /dev/null

    if [ ! -f "$EXEC" ]; then
      echo -e "${YELLOW}Compiling $EXP_DIR...${RESET}"
      if [ "$LANG" = "go" ]; then
        go build -o "$EXEC" main.go
      elif [ "$LANG" = "rust" ]; then
        rustc -C opt-level=3 main.rs -o "$EXEC"
      elif [ "$LANG" = "c" ]; then
        gcc -O3 main.c -o "$EXEC"
      fi
    fi

    for i in $(seq 1 $RUNS); do
      echo -e "${CYAN}Run #$i:${RESET}"
      time ./$EXEC
    done

    popd > /dev/null
  done
done


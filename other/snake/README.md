# Snake Game

This is a simple terminal-based Snake game written in C using `ncurses` for rendering and optional `SDL2_mixer` for background music.

## How to Play
- Use **arrow keys** to control the snake.
- Eat the **'x'** (food) to grow in size.
- Avoid hitting the **walls (`#`)** or **your own body**, or the game will end.

## Installation & Running
### Prerequisites
Ensure you have the following installed:
- `gcc` (or `clang`)
- `ncurses`
- (Optional) `SDL2_mixer` for background music

### Install Dependencies
#### **Linux (Debian-based)**
```sh
sudo apt-get install libncurses5-dev libsdl2-dev libsdl2-mixer-dev
```

#### **macOS (Homebrew)**
```sh
brew install ncurses sdl2 sdl2_mixer
```

### Compile the Game
#### **Without Music**
```sh
gcc snake.c -o snake -lncurses
```

#### **With Music (Optional)**
```sh
gcc snake.c -o snake -I/opt/homebrew/include/SDL2 -D_REENTRANT -L/opt/homebrew/lib -lSDL2 -lSDL2_mixer -lncurses
```

### Run the Game
```sh
./snake
```

## Notes
- If music is enabled, make sure `background.mp3` is in the same directory.
- Press **Ctrl + C** to exit if needed.

Enjoy the game! 🐍🎮



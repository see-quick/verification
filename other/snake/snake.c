#include <curses.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <SDL.h>
#include <SDL_mixer.h>

#define MAX_LENGTH 100  // Max snake length
#define WIDTH  40       // Game width
#define HEIGHT 20       // Game height

void draw_walls() {
    for (int x = 0; x <= WIDTH; x++) {
        mvaddch(0, x, '#');           // Top wall
        mvaddch(HEIGHT, x, '#');      // Bottom wall
    }
    for (int y = 0; y <= HEIGHT; y++) {
        mvaddch(y, 0, '#');           // Left wall
        mvaddch(y, WIDTH, '#');       // Right wall
    }
}

void generate_food(int* foodX, int* foodY, int snakeX[], int snakeY[], int snakeLength) {
    while (1) {
        *foodX = (rand() % (WIDTH - 2)) + 1;  // Avoid spawning on walls
        *foodY = (rand() % (HEIGHT - 2)) + 1;

        // Ensure food does not spawn on the snake body
        int valid = 1;
        for (int i = 0; i < snakeLength; i++) {
            if (*foodX == snakeX[i] && *foodY == snakeY[i]) {
                valid = 0;
                break;
            }
        }
        if (valid) break;
    }
}

int check_collision(int snakeX[], int snakeY[], int snakeLength) {
    // Check if the snake head collides with its body
    for (int i = 1; i < snakeLength; i++) {
        if (snakeX[0] == snakeX[i] && snakeY[0] == snakeY[i]) {
            printf("Colision...\n");
            return 1; // Collision detected
        }
    }
    return 0;
}


int main() {
  WINDOW* win = initscr();

  // Initialize SDL and SDL_mixer
  if (SDL_Init(SDL_INIT_AUDIO) < 0) {
    printf("SDL could not initialize! SDL_Error: %s\n", SDL_GetError());
    return 1;
  }

  if (Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0) {
     printf("SDL_mixer could not initialize! Mix_Error: %s\n", Mix_GetError());
    return 1;
   }

  Mix_Music *bgMusic = Mix_LoadMUS("arcade.mp3"); // Ensure the file exists
  if (!bgMusic) {
    printf("Failed to load music! Mix_Error: %s\n", Mix_GetError());
    return 1;
  }

  Mix_PlayMusic(bgMusic, -1); // Loop background music

  keypad(win, true);
  nodelay(win, true);
  curs_set(0);  // Hide cursor

  int snakeX[MAX_LENGTH] = {10};  // X coordinates of the snake body
  int snakeY[MAX_LENGTH] = {10};  // Y coordinates of the snake body
  int snakeLength = 1;  // Initial snake size

  int foodX = rand() % 20;
  int foodY = rand() % 20;
  int dirX = 1;
  int dirY = 0;

  generate_food(&foodX, &foodY, snakeX, snakeY, snakeLength);

  while(true) {
    int pressed = wgetch(win);
    if (pressed == KEY_LEFT) {
      dirX = -1;
      dirY = 0;
    }
    if (pressed == KEY_RIGHT) {
      dirX = 1;
      dirY = 0;
    }
    if (pressed == KEY_UP) {
      dirX = 0;
      dirY = -1;
    }
    if (pressed == KEY_DOWN) {
      dirX = 0;
      dirY = 1;
    }
    
    // Move the snake body
    for (int i = snakeLength - 1; i > 0; i--) {
      snakeX[i] = snakeX[i - 1];
      snakeY[i] = snakeY[i - 1];
    }

    // Move the head
    snakeX[0] += dirX;
    snakeY[0] += dirY;

    // Check collision with food
    if (snakeX[0] == foodX && snakeY[0] == foodY) {
      if (snakeLength < MAX_LENGTH) snakeLength++;
      generate_food(&foodX, &foodY, snakeX, snakeY, snakeLength);
    }

    // Check for self-collision or wall collision
    if (snakeX[0] <= 0 || snakeX[0] >= WIDTH || snakeY[0] <= 0 || snakeY[0] >= HEIGHT) {
        printf("Wall colision\n");
        break;  // End game if hitting wall
    }
    
    // Check for self-collision
    if (check_collision(snakeX, snakeY, snakeLength)) {
       break; // End game if the snake collides with itself
    }    
  
    erase();
    draw_walls();

    mvaddstr(foodY, foodX, "x");
    
    for (int i = 0; i < snakeLength; i++) {
      mvaddstr(snakeY[i], snakeX[i], "*");
    }

    refresh();
    usleep(100000);
  }
  
  endwin();

  Mix_FreeMusic(bgMusic);
  Mix_CloseAudio();
  SDL_Quit();

  printf("Game Over! Your score: %d\n", snakeLength - 1);

  return 0;
}

      














#include <curses.h>
#include <locale.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <SDL.h>
#include <SDL_mixer.h>

#define MAX_LENGTH 100  // Max snake length
#define WIDTH  50       // Game width
#define HEIGHT 25      // Game height (excluding scoreboard row)
#define SCOREBOARD_HEIGHT 1  // Scoreboard row height

void draw_walls() {
    for (int x = 0; x <= WIDTH; x++) {
        mvprintw(SCOREBOARD_HEIGHT, x, "#");           // Top wall (below scoreboard)
        mvprintw(HEIGHT + SCOREBOARD_HEIGHT, x, "#");  // Bottom wall
    }
    for (int y = SCOREBOARD_HEIGHT; y <= HEIGHT + SCOREBOARD_HEIGHT; y++) {
        mvprintw(y, 0, "#");           // Left wall
        mvprintw(y, WIDTH, "#");       // Right wall
    }
}

void generate_food(int* foodX, int* foodY, int snakeX[], int snakeY[], int snakeLength) {
    while (1) {
        *foodX = (rand() % (WIDTH - 2)) + 1;  // Avoid spawning on walls
        *foodY = (rand() % (HEIGHT - 2)) + SCOREBOARD_HEIGHT + 1;  // Avoid scoreboard row

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
    for (int i = 1; i < snakeLength; i++) {
        if (snakeX[0] == snakeX[i] && snakeY[0] == snakeY[i]) {
            return 1; // Collision detected
        }
    }
    return 0;
}

void draw_scoreboard(int score) {
    mvprintw(0, WIDTH / 2 - 6, " Score: %d ", score);
}

int main() {
    setlocale(LC_ALL, "");  // Enable Unicode rendering
    srand(time(NULL));

    if (SDL_Init(SDL_INIT_AUDIO) < 0) {
        printf("SDL could not initialize! SDL_Error: %s\n", SDL_GetError());
        return 1;
    }

    if (Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0) {
        printf("SDL_mixer could not initialize! Mix_Error: %s\n", Mix_GetError());
        return 1;
    }

    Mix_Music *bgMusic = Mix_LoadMUS("arcade.mp3");
    if (!bgMusic) {
        printf("Failed to load music! Mix_Error: %s\n", Mix_GetError());
        return 1;
    }
    Mix_PlayMusic(bgMusic, -1);

    WINDOW* win = initscr();
    keypad(win, true);
    nodelay(win, true);
    curs_set(0);
    noecho();

    int snakeX[MAX_LENGTH] = {10};
    int snakeY[MAX_LENGTH] = {SCOREBOARD_HEIGHT + 10}; // Adjusted to not spawn on scoreboard
    int snakeLength = 1;
    int dirX = 1, dirY = 0;

    int foodX, foodY;
    generate_food(&foodX, &foodY, snakeX, snakeY, snakeLength);

    while (true) {
        int pressed = wgetch(win);
        if (pressed == KEY_LEFT && dirX == 0) { dirX = -1; dirY = 0; }
        if (pressed == KEY_RIGHT && dirX == 0) { dirX = 1; dirY = 0; }
        if (pressed == KEY_UP && dirY == 0) { dirX = 0; dirY = -1; }
        if (pressed == KEY_DOWN && dirY == 0) { dirX = 0; dirY = 1; }

        for (int i = snakeLength - 1; i > 0; i--) {
            snakeX[i] = snakeX[i - 1];
            snakeY[i] = snakeY[i - 1];
        }

        snakeX[0] += dirX;
        snakeY[0] += dirY;

        if (snakeX[0] <= 0 || snakeX[0] >= WIDTH || snakeY[0] <= SCOREBOARD_HEIGHT || snakeY[0] >= HEIGHT + SCOREBOARD_HEIGHT) {
            break;
        }

        if (check_collision(snakeX, snakeY, snakeLength)) {
            break;
        }

        if (snakeX[0] == foodX && snakeY[0] == foodY) {
            if (snakeLength < MAX_LENGTH) snakeLength++;
            generate_food(&foodX, &foodY, snakeX, snakeY, snakeLength);
        }

        erase();
        draw_scoreboard(snakeLength - 1);  // Display score
        draw_walls();
        mvaddstr(foodY, foodX, "x");

        for (int i = 0; i < snakeLength; i++) {
            mvaddstr(snakeY[i], snakeX[i], "■");
        }

        refresh();
        usleep(100000);
    }

    
    mvaddstr(HEIGHT / 2, WIDTH / 2 - 10, "Game over you suck... :D!");
    refresh();
    sleep(2);
    endwin();
    Mix_FreeMusic(bgMusic);
    Mix_CloseAudio();
    SDL_Quit();
    return 0;
}

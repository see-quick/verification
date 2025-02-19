#include <curses.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <locale.h>
#include <SDL.h>
#include <SDL_mixer.h>

#define WIDTH 50
#define HEIGHT 20
#define PADDLE_HEIGHT 5
#define BALL_CHAR 'O'
#define PADDLE_CHAR '|'
#define P1_UP 'w'
#define P1_DOWN 's'
#define P2_UP KEY_UP
#define P2_DOWN KEY_DOWN

typedef struct {
    int x, y;
    int dx, dy;
} Ball;

typedef struct {
    int y;
} Paddle;

void draw_paddle(int x, int y) {
    for (int i = 0; i < PADDLE_HEIGHT; i++) {
        mvaddch(y + i, x, PADDLE_CHAR);
    }
}

void draw_ball(Ball* ball) {
    mvaddch(ball->y, ball->x, BALL_CHAR);
}

int check_collision(Ball* ball, Paddle* paddle, int x) {
    return (ball->x == x && ball->y >= paddle->y && ball->y < paddle->y + PADDLE_HEIGHT);
}

void reset_ball(Ball* ball) {
    ball->x = WIDTH / 2;
    ball->y = HEIGHT / 2;
    ball->dx = (rand() % 2 == 0) ? 1 : -1;
    ball->dy = (rand() % 2 == 0) ? 1 : -1;
}

// Function to handle Ctrl+C (SIGINT)
void handle_exit(int sig) {
    endwin();  // Reset ncurses terminal
    Mix_CloseAudio();
    SDL_Quit();
    exit(0);
}

int main() {
    srand(time(NULL));
    setlocale(LC_ALL, "");
    signal(SIGINT, handle_exit);

    // SDL Initialization for sound
    if (SDL_Init(SDL_INIT_AUDIO) < 0) {
        printf("SDL could not initialize! SDL_Error: %s\n", SDL_GetError());
        return 1;
    }

    if (Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0) {
        printf("SDL_mixer could not initialize! Mix_Error: %s\n", Mix_GetError());
        return 1;
    }

    Mix_Music *bgMusic = Mix_LoadMUS("background.mp3");
    if (!bgMusic) {
        printf("Failed to load music! Mix_Error: %s\n", Mix_GetError());
        return 1;
    }
    Mix_PlayMusic(bgMusic, -1);

    Mix_Chunk* bounceSound = Mix_LoadWAV("ping.mp3");
    Mix_Chunk* scoreSound = Mix_LoadWAV("score_sound.mp3");
    if (!bounceSound || !scoreSound) {
        printf("Failed to load sounds! Mix_Error: %s\n", Mix_GetError());
        return 1;
    }

    // ncurses initialization
    initscr();
    noecho();
    curs_set(0);
    keypad(stdscr, TRUE);
    nodelay(stdscr, TRUE);
    timeout(200);

    Paddle p1 = {HEIGHT / 2 - PADDLE_HEIGHT / 2};
    Paddle p2 = {HEIGHT / 2 - PADDLE_HEIGHT / 2};
    Ball ball;
    reset_ball(&ball);

    int score1 = 0, score2 = 0;

    while (1) {
        int key = getch();

        if (key == 'q') break;  // Quit game

        // Player 1 controls
        if (key == P1_UP && p1.y > 0) p1.y--;
        if (key == P1_DOWN && p1.y < HEIGHT - PADDLE_HEIGHT) p1.y++;

        // Player 2 controls
        if (key == P2_UP && p2.y > 0) p2.y--;
        if (key == P2_DOWN && p2.y < HEIGHT - PADDLE_HEIGHT) p2.y++;

        // Move ball
        ball.x += ball.dx;
        ball.y += ball.dy;

        // Bounce off top/bottom walls
        if (ball.y <= 0 || ball.y >= HEIGHT - 1) {
            ball.dy *= -1;
            Mix_PlayChannel(-1, bounceSound, 0);
        }

        // Bounce off paddles
        if (check_collision(&ball, &p1, 1) || check_collision(&ball, &p2, WIDTH - 2)) {
            ball.dx *= -1;
            Mix_PlayChannel(-1, bounceSound, 0);
        }

        // Score points
        if (ball.x <= 0) {
            score2++;
            Mix_PlayChannel(-1, scoreSound, 0);
            reset_ball(&ball);
        } else if (ball.x >= WIDTH - 1) {
            score1++;
            Mix_PlayChannel(-1, scoreSound, 0);
            reset_ball(&ball);
        }

        // Draw everything
        clear();
        mvprintw(0, WIDTH / 2 - 6, "Score: %d - %d", score1, score2);
        draw_paddle(1, p1.y);
        draw_paddle(WIDTH - 2, p2.y);
        draw_ball(&ball);
        refresh();
    }

    // Cleanup
    Mix_FreeChunk(bounceSound);
    Mix_FreeChunk(scoreSound);
    Mix_CloseAudio();
    SDL_Quit();
    endwin();

    return 0;
}
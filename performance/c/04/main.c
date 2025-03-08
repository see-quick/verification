#include <ev.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 8080
#define RESPONSE "HTTP/1.1 200 OK\r\nContent-Length: 13\r\n\r\nHello, World!"

void handle_request(EV_P_ ev_io *w, int revents) {
    char buffer[1024];
    int client_fd = w->fd;
    read(client_fd, buffer, sizeof(buffer));
    write(client_fd, RESPONSE, sizeof(RESPONSE) - 1);
    close(client_fd);
    ev_io_stop(EV_A_ w);
    free(w);
}

void accept_cb(EV_P_ ev_io *w, int revents) {
    int server_fd = w->fd;
    struct sockaddr_in client_addr;
    socklen_t client_len = sizeof(client_addr);
    int client_fd = accept(server_fd, (struct sockaddr *)&client_addr, &client_len);
    ev_io *client_watcher = malloc(sizeof(ev_io));
    ev_io_init(client_watcher, handle_request, client_fd, EV_READ);
    ev_io_start(EV_A_ client_watcher);
}

int main() {
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in addr = { .sin_family = AF_INET, .sin_addr.s_addr = INADDR_ANY, .sin_port = htons(PORT) };
    bind(server_fd, (struct sockaddr *)&addr, sizeof(addr));
    listen(server_fd, 128);

    struct ev_loop *loop = EV_DEFAULT;
    ev_io server_watcher;
    ev_io_init(&server_watcher, accept_cb, server_fd, EV_READ);
    ev_io_start(loop, &server_watcher);

    printf("C HTTP server running on port %d\n", PORT);
    ev_run(loop, 0);
}

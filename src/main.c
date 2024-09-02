#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "day.h"
#include "darray.h"

#include "raylib.h"

int main(int argc, char **argv) {
    printf("[MAIN] Trying my hand at C??\n");

    char *p1 = calloc(RES_MAX_LENGTH, sizeof(char));
    char *p2 = calloc(RES_MAX_LENGTH, sizeof(char));
    int code = run(p1, p2);

    printf("[MAIN] Puzzle solution (code = %i)\n", code);
    printf(" - Part 1 = '%s'\n", p1);
    printf(" - Part 2 = '%s'\n", p2);

    free(p1);
    free(p2);

    if (argc > 1 && strcmp(argv[1], "--test") == 0) {
        _arr_tests();
    }

    InitWindow(800, 600, "AWWWW yea!");
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(BLACK);
        EndDrawing();
    }
    CloseWindow();

    return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "day.h"
#include "darray.h"
#include "raylib.h"

int init_day(char **out_p1, char **out_p2) {
    *out_p1 = calloc(RES_MAX_LENGTH, sizeof(char));
    if (*out_p1 == NULL) {
        return -1;
    }

    *out_p2 = calloc(RES_MAX_LENGTH, sizeof(char));
    if (*out_p2 == NULL) {
        return -1;
    }

    return 0;
}

void clean_day(char *p1, char *p2) {
    free(p1);
    p1 = NULL;
    free(p2);
    p2 = NULL;
}

int main(int argc, char **argv) {
    printf("[MAIN] Trying my hand at C??\n");

    char *p1 = NULL;
    char *p2 = NULL;
    if (init_day(&p1, &p2) < 0) {
        printf("[MAIN] Could not initialize answer buffers\n");
        return EXIT_FAILURE;
    }

    int code = run(p1, p2);
    printf("[MAIN] Puzzle solution (code = %i)\n", code);
    printf(" - Part 1 = '%s'\n", p1);
    printf(" - Part 2 = '%s'\n", p2);
    clean_day(p1, p2);

    if (argc > 1 && strcmp(argv[1], "--test") == 0) {
        _arr_tests();
    }

    if (argc > 1 && strcmp(argv[1], "--raylib") == 0) {
        InitWindow(800, 600, "AWWWW yea!");
        while (!WindowShouldClose()) {
            BeginDrawing();
            ClearBackground(BLACK);
            EndDrawing();
        }
        CloseWindow();
    }

    return EXIT_SUCCESS;
}

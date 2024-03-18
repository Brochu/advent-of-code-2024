#include "day.h"
#include "darray.h"
#include "parsing.h"
#include "strview.h"

#include <stdio.h>
#include <stdlib.h>

#define DEMO 1
#if DEMO == 1 // ------------------------------------
//#define FILE_PATH ".\\inputs\\day0_demo1.txt"
#define FILE_PATH ".\\inputs\\file.txt"
#else // ------------------------------------
#define FILE_PATH ".\\inputs\\day0.txt"
#endif // ------------------------------------

typedef struct game {
    size_t id;
    int maxes[3];
} game;

int part1(char *out, game *games) {
    size_t sum = 0;
    int totals[3] = { 12, 13, 14 };

    printf("Games: size=%lld, cap=%lld\n", arr_size(games), arr_cap(games));
    for(int i = 0; i < arr_size(games); i++) {
        printf("Game(%lld) -> [r]: %i ; [g]: %i ; [b]: %i\n",
               games[i].id, games[i].maxes[0], games[i].maxes[1], games[i].maxes[2]);
        if (games[i].maxes[0] <= totals[0] && games[i].maxes[1] <= totals[1] && games[i].maxes[2] <= totals[2]) {
            sum += games[i].id;
        }
    }

    sprintf_s(out, RES_MAX_LENGTH, "%d", sum);
    return 0;
}

int part2(char *out) {
    sprintf_s(out, RES_MAX_LENGTH, "NotCompleted : %d", 69);
    return 0;
}


int run(char *part1_out, char *part2_out) {
    char *in = read_file(FILE_PATH);
    game *games = arr_init(game);

    strview *lines = chr_split(in, "\n");
    for (int i = 0; i < arr_size(lines); i++) {
        strview first;
        strview rest;
        str_split_once(lines[i], ": ", &first, &rest);

        size_t id = 0;
        sscanf_s(first.ptr, "Game %lld", &id);
        game g = { .id = id, .maxes = {0} };

        strview *draws = str_split(rest, "; ");
        for (int j = 0; j < arr_size(draws); j++) {
            strview *elems = str_split(draws[j], ", ");
            for (int k = 0; k < arr_size(elems); k++) {
                strview count;
                strview color;
                str_split_once(elems[k], " ", &count, &color);

                int c = 0;
                sscanf_s(count.ptr, "%i", &c);
                char col = color.ptr[0];
                g.maxes[col%3] = max(g.maxes[col%3], c);
            }
        }
        arr_push(games, g);
    }

    part1(part1_out, games);
    part2(part2_out);

    free(in);
    return 0;
}

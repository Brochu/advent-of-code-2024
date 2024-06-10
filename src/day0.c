#include "day.h"
#include "darray.h"
#include "parsing.h"
#include "strview.h"

#include <stdio.h>
#include <stdlib.h>

#define DEMO 1
#if DEMO == 1 // ------------------------------------
#define FILE_PATH ".\\inputs\\day0_demo.txt"
#else // ------------------------------------
#define FILE_PATH ".\\inputs\\day0.txt"
#endif // ------------------------------------

typedef struct {
    size_t stride;
    int *vals;
} grid;

void debug_grid(grid *g) {
    for (int i = 0; i < g->stride * g->stride; i++) {
        printf("[%i] -> %i\n", i, g->vals[i]);
    }
}

int part1(grid *g, char *out) {
    debug_grid(g);
    sprintf_s(out, RES_MAX_LENGTH, "%d", 0);
    return 0;
}

int part2(grid *g, char *out) {
    sprintf_s(out, RES_MAX_LENGTH, "%d", 0);
    return 0;
}

int run(char *part1_out, char *part2_out) {
    char *in = read_file(FILE_PATH);
    strview input = FromCString(in);
    printf(""STR_FMT"", STR_ARG(input));

    grid g = { .vals = NULL, .stride = 0 };

    strview *lines = chr_split(in, "\n");
    g.stride = arr_size(lines);
    g.vals = calloc(g.stride * g.stride, sizeof(int));

    for (int i = 0; i < arr_size(lines); i++) {
        strview *nodes = str_split(lines[i], ", ");
        for (int j = 0; j < arr_size(nodes); j++) {
            printf("'"STR_FMT"'", STR_ARG(nodes[j]));
            g.vals[j + (i * g.stride)] = atoi(nodes[j].ptr);
        }
        printf("\n");
    }

    part1(&g, part1_out);
    part2(&g, part2_out);

    free(g.vals);
    free(in);
    return 0;
}
